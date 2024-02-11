terraform {
  required_version = ">= 0.13"
  required_providers {
    artifactory = {
      source = "jfrog/artifactory"
      version = "10.1.2"
    }
  }
}
