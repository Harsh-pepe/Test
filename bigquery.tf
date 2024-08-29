module "bigquery" {
  for_each   = local.bigquery_datasets
  source     = "app.terraform.io/hca-healthcare/bigquery/gcp"
  version    = "1.0.2"
  project_id = var.gcp_project_id_prod  # Use a production project ID variable
  location   = try(each.value.location, var.gcp_region_prod)  # Use a production region variable
  labels     = module.tagging.metadata
  dataset_id = each.value.dataset_id
  ml_group   = try(each.value.ml_group, [])
  user_group = try(each.value.user_group, [])
  tables     = try(each.value.tables, [])
}

locals {
  iam_to_primitive = {
    "roles/bigquery.dataOwner" : "OWNER"
    "roles/bigquery.dataEditor" : "WRITER"
    "roles/bigquery.dataViewer" : "READER"
  }

  dataset_access = flatten([
    for dataset in local.bigquery_datasets : [
      for access in try(dataset.access, []) : merge(access, {
        dataset_id = dataset.dataset_id
      })
    ]
  ])
  
  ua = { for access in local.dataset_access : "${access.dataset_id}-${access.assignee}-${access.role}-${access.type}" => access }
}

resource "google_bigquery_dataset_access" "custom" {
  for_each       = { for item in local.ua : join("/", [item.dataset_id, item.role, item.assignee, item.type]) => item }
  dataset_id     = each.value.dataset_id
  project        = var.project_id  # Use the production project ID
  role           = local.iam_to_primitive[each.value.role]
  user_by_email  = each.value.type == "user_by_email" ? each.value.assignee : null
  group_by_email = each.value.type == "group_by_email" ? lower(each.value.assignee) : null
  special_group  = each.value.type == "special_group" ? each.value.assignee : null
  depends_on     = [module.bigquery]
}