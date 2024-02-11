resource "artifactory_local_maven_repository" "maven_snapshots" {
  key                             = "maven-snapshots"
  checksum_policy_type            = "client-checksums"
  snapshot_version_behavior       = "unique"
  max_unique_snapshots            = 10
  handle_releases                 = false
  handle_snapshots                = true
  suppress_pom_consistency_checks = false
}

resource "artifactory_local_maven_repository" "maven_releases" {
  key                             = "maven-releases"
  checksum_policy_type            = "client-checksums"
  snapshot_version_behavior       = "unique"
  handle_releases                 = true
  handle_snapshots                = false
  suppress_pom_consistency_checks = false
}

resource "artifactory_remote_maven_repository" "repo1_maven_org" {
  key                                = "repo1.maven.org"
  url                                = "https://repo1.maven.org/maven2/"
  fetch_jars_eagerly                 = true
  fetch_sources_eagerly              = false
  suppress_pom_consistency_checks    = false
  reject_invalid_jars                = true
  metadata_retrieval_timeout_secs    = 120
}

resource "artifactory_virtual_maven_repository" "maven_all" {
  key             = "maven-all"
  repo_layout_ref = "maven-2-default"
  repositories    = [
    "${artifactory_local_maven_repository.maven_snapshots.key}",
    "${artifactory_local_maven_repository.maven_releases.key}",
    "${artifactory_remote_maven_repository.repo1_maven_org.key}"
  ]
  description                              = "Maven All"
  force_maven_authentication               = true
  pom_repository_references_cleanup_policy = "discard_active_reference"
}

resource "artifactory_local_docker_v2_repository" "docker_snapshots" {
  key               = "docker-snapshots"
  tag_retention   = 3
  max_unique_tags = 5
}

resource "artifactory_local_docker_v2_repository" "docker_releases" {
  key               = "docker-releases"
  tag_retention   = 1
  max_unique_tags = 1
}

resource "artifactory_remote_docker_repository" "registry_1_docker_io" {
  key                            = "registry-1.docker.io"
  external_dependencies_enabled  = true
  external_dependencies_patterns = ["**/registry-1.docker.io/**"]
  enable_token_authentication    = true
  url                            = "https://registry-1.docker.io/"
  block_pushing_schema1          = true
}

resource "artifactory_virtual_docker_repository" "docker_all" {
  key                               = "docker-all"
  repositories                      = [
    "${artifactory_local_docker_v2_repository.docker_snapshots.key}",
    "${artifactory_local_docker_v2_repository.docker_releases.key}",
    "${artifactory_remote_docker_repository.registry_1_docker_io.key}"
  ]
  description                       = "Docker All"
  resolve_docker_tags_by_timestamp  = true
}
