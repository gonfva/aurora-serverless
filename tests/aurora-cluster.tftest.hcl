provider "aws" {
  region = "eu-west-2"
}

run "setup_tests" {
    module {
        source = "./tests/setup"
    }
}

run "create_cluster" {
  command = apply

  variables {
    cluster_name = "test-create-cluster"
    tags = { Application = "Just a test"}
    environment_type = "dev"
    engine_type = "pg"
    vpc_id = run.setup_tests.vpc_id
    subnet_ids = run.setup_tests.subnet_ids
    db_name = "db_name"
    db_users = {
        admin = "admin_user"
        ro = "ro_user"
        rw = "rw_user"
    }
  }


  assert {
    condition     = aws_rds_cluster.cluster.cluster_identifier == var.cluster_name
    error_message = "Invalid name"
  }

  assert {
    condition     = jsondecode(data.local_file.results.content).body == "Users created successfully"
    error_message = "Error "
  }

}
