resource "harbor_garbage_collection" "main" {
  delete_untagged = true
  schedule        = "0 30 */12 * * 0"
  workers         = 2
}

resource "harbor_purge_audit_log" "main" {
  audit_retention_hour = 360
  include_event_types  = "create_artifact,delete_artifact,pull_artifact,other"
  schedule             = "0 0 */12 * * *"
}
