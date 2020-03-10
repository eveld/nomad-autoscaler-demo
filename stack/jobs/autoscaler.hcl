job "autoscaler" {
  datacenters = ["dc1"]

  group "autoscaler" {
    count = 1

    task "autoscaler" {
      driver = "docker"

      config {
        image          = "shipyardrun/nomad-autoscaler:v0.10.4-custom"
      }

      resources {
        cpu = 50
        memory = 128

        network {
          mbits = 10
        }
      }
    }
  }
}