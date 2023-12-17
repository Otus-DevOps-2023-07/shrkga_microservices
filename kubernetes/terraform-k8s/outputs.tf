output "cluster_external_v4_endpoint" {
  description = "An IPv4 external network address that is assigned to the master"
  value       = yandex_kubernetes_cluster.reddit_cluster.master[0].external_v4_endpoint
}