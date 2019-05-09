terragrunt = {
  remote_state {
    backend = "s3"

    config {
      encrypt        = true
      bucket         = ""
      key            = "${path_relative_to_include()}/terraform.tfstate"
      region         = ""
      dynamodb_table = ""

      s3_bucket_tags {
        Terraform   = true
        Environment = "Dev"
      }

      dynamodb_table_tags {
        owner       = "terragrunt"
        name        = "Terraform lock table"
        Terraform   = true
        Environment = "Dev"
      }
    }
  }

  terraform {
    extra_arguments "retry_lock" {
      commands = [
        "init",
        "apply",
        "refresh",
        "import",
        "plan",
        "taint",
        "untaint",
      ]

      arguments = [
        "-lock-timeout=0s",
      ]

      extra_arguments "global_vars" {
        arguments = [
          "-var",
          "region=eu-west-1",
          "-var",
          "env_type=Dev",
        ]

        commands = [
          "apply",
          "plan",
          "import",
          "push",
          "refresh",
          "destroy",
          "validate",
        ]
      }
    }
  }
}
