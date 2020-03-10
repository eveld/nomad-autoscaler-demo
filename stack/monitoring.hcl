// container "prometheus" {
//   image {
//     name = "prom/prometheus:latest"
//   }

//   volume {
//     source      = "./prometheus_config"
//     destination = "/etc/prometheus/"
//   }

//   network {
//     name = "network.onprem"
//     ip_address = "10.5.0.30"
//   }
// }

// container "grafana" {
//   image {
//     name = "grafana/grafana"
//   }

//   network {
//     name = "network.onprem"
//     ip_address = "10.5.0.40"
//   }
// }