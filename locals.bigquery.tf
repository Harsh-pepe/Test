locals {
  soj_group = [
    "group:aad_hca-soj-prod-proj@hca.corpad.net",
    "serviceAccount:svc-soj-ff89ae@hca-soj-prod.iam.gserviceaccount.com"
  ]
  # TODO: It seems like these are redundant but I'm not positive? the dataEditor role should already be granted via the
  #  ml_group configuration which specifies the same Soj AD group and Soj service account
  soj_access = [
    {
      role     = "roles/bigquery.dataEditor", type = "user_by_email",
      assignee = "svc-soj-ff89ae@hca-soj-prod.iam.gserviceaccount.com"
    },
    {
      role     = "roles/bigquery.dataEditor", type = "group_by_email",
      assignee = "aad_hca-soj-prod-proj@hca.corpad.net"
    }
  ]
  bigquery_datasets = {
    soj_internal = {
      dataset_id = "soj_internal"
      ml_group = [
        "group:aad_hca-soj-prod-proj@hca.corpad.net",
      ]
      location = "us"
      tables = [
        {
          table_id = "headhunter"
          schema   = file("./bq-schemas/headhunter-schema.json")
        }, {
          table_id = "headhunter_partitioned"
          schema   = file("./bq-schemas/headhunter-schema.json")
          time_partitioning = {
            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,
          }
        }, {
          table_id = "spot-client_partitioned"
          schema   = file("./bq-schemas/spot-client.json")
          time_partitioning = {
            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,
          }
        }
      ]
    }


    ds_feature_engineering = {
      dataset_id = "ds_feature_engineering"
      ml_group = [
        "group:aad_hca-soj-prod-proj@hca.corpad.net",
        "serviceAccount:svc-soj-ff89ae@hca-soj-prod.iam.gserviceaccount.com"]
      access = [
        { role     = "roles/bigquery.dataViewer", type = "group_by_email",
          assignee = "aad_clinical_data_scientist@hca.corpad.net"
          }, {
          role     = "roles/bigquery.dataViewer", type = "user_by_email",
          assignee = "gcp-2lw-un-d06bcd-hge4834@hca-dsa-2lw-train.iam.gserviceaccount.com"
          }, {
          role     = "roles/bigquery.dataViewer", type = "user_by_email",
          assignee = "gcp-2lw-un-2a26d1-eld6838@hca-dsa-2lw-train.iam.gserviceaccount.com"
          }, {
          role     = "roles/bigquery.dataViewer", type = "user_by_email",
          assignee = "gcp-dsa-un-0e7807-hge4834@hca-dsa-scheduling-train.iam.gserviceaccount.com"
        }
      ]
      location = "us"
      tables = [
        {
          table_id = "adt_test"
          schema   = file("./bq-schemas/ds-adt-test-schema.json")
          time_partitioning = {
            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,
          }
        }
      ]
    }
    patient_signs = {
      dataset_id = "patient_signs"
      ml_group   = local.soj_group
      access     = local.soj_access
      location   = "us"
      tables = [
        {
          table_id = "patient_signs_example"
          schema   = file("./bq-schemas/patient-signs-schema.json")
          time_partitioning = {
            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,
          }
        }
      ]
    }
    sofa_reporting = {
      dataset_id = "sofa_reporting"
      ml_group = [
        "group:aad_hca-soj-prod-proj@hca.corpad.net",
        "serviceAccount:svc-soj-419ca2@hca-soj-prod.iam.gserviceaccount.com"
      ]
      access = [
        {
          role     = "roles/bigquery.dataEditor", type = "user_by_email",
          assignee = "svc-soj-419ca2@hca-soj-prod.iam.gserviceaccount.com"
        },

        {
          role     = "roles/bigquery.dataEditor", type = "group_by_email",
          assignee = "aad_hca-soj-prod-proj@hca.corpad.net"
        }
      ]
      location = "us"
      tables = [
        {
          table_id = "sofa_score_report"
          schema   = file("./bq-schemas/sofa-score-report-schema.json")
        },
        {
          table_id = "sofa_score_report_testing"
          schema   = file("./bq-schemas/sofa-score-report-schema.json")
        }
      ]
    }
    soj_reporting = {
      dataset_id = "soj_reporting"
      ml_group = [
        "group:aad_hca-soj-prod-proj@hca.corpad.net",
        "serviceAccount:svc-soj-419ca2@hca-soj-prod.iam.gserviceaccount.com"
      ]
      access = [
        {
          role     = "roles/bigquery.dataEditor", type = "user_by_email",
          assignee = "svc-soj-419ca2@hca-soj-prod.iam.gserviceaccount.com"
        },

        {
          role     = "roles/bigquery.dataEditor", type = "group_by_email",
          assignee = "aad_hca-soj-prod-proj@hca.corpad.net"
        }
      ]
      locations = "us"
      tables = [
        {
          table_id = "sofa_score_report"
          schema   = file("./bq-schemas/sofa-score-report-schema.json")
        },
        {
          table_id = "sofa_score_report_testing"
          schema   = file("./bq-schemas/sofa-score-report-schema.json")
        },
        {
          table_id = "sofa_score_client"
          schema   = file("./bq-schemas/sofa-client-schema.json")
          time_partitioning = {
            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,
          }
        }
      ]
    }
    hca_google_collab = {
      dataset_id = "hca_google_collab"
      ml_group   = local.soj_group
      access     = [
        {
          role     = "roles/bigquery.dataViewer",
          type     = "group_by_email",
          assignee = "aad_clinical_data_scientist@hca.corpad.net"
        },{
          role     = "roles/bigquery.dataViewer",
          type     = "user_by_email",
          assignee = "gcp-ayo-un-850099-hge4834@hca-ayo-dev.iam.gserviceaccount.com"
        }
      ]
      location   = "us"
      tables = [
        {
          table_id = "fax_machine_airdale"
          schema   = file("./bq-schemas/airdale-schema.json")
          time_partitioning = {
            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,
          }
        },
        {
          table_id = "fax_machine_bones"
          schema   = file("./bq-schemas/bones-schema.json")
          time_partitioning = {
            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,
          }
        },
        {
          table_id = "fax_machine_dianoga"
          schema   = file("./bq-schemas/dianoga-schema.json")
          time_partitioning = {
            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,
          }
        },
        {
          table_id = "fax_machine_hound_administration"
          schema   = file("./bq-schemas/hound-administration-schema.json")
          time_partitioning = {
            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,
          }
        },
        {
          table_id = "fax_machine_hound_order"
          schema   = file("./bq-schemas/hound-order-schema.json")
          time_partitioning = {
            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,
          }
        },
        {
          table_id = "fax_machine_lab_orders"
          schema   = file("./bq-schemas/lab-orders-schema.json")
          time_partitioning = {
            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,
          }
        },
        {
          table_id = "fax_machine_lab_results"
          schema   = file("./bq-schemas/lab-results-schema.json")
          time_partitioning = {
            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,
          }
        },
        {
          table_id = "fax_machine_spaniel"
          schema   = file("./bq-schemas/spaniel-schema.json")
          time_partitioning = {
            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,
          }
        },
        {
          table_id = "fax_machine_xolo"
          schema   = file("./bq-schemas/xolo-schema.json")
          time_partitioning = {
            type                     = "DAY",
            field                    = null,
            require_partition_filter = false,
            expiration_ms            = null,
          }
        }
      ]
    }
  }
}