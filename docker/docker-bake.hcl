group "default" {
  targets = [
    "visualizer",
    "scenario-simulator",
    "autoware",
  ]
}

// For docker/metadata-action
target "docker-metadata-action-visualizer" {}
target "docker-metadata-action-scenario-simulator" {}
target "docker-metadata-action-autoware" {}

target "visualizer" {
  inherits = ["docker-metadata-action-visualizer"]
  dockerfile = "docker/visualizer/Dockerfile"
  target = "visualizer"
}

target "scenario-simulator" {
  inherits = ["docker-metadata-action-scenario-simulator"]
  dockerfile = "docker/scenario-simulator/Dockerfile"
  target = "scenario-simulator"
}

target "autoware" {
  inherits = ["docker-metadata-action-autoware"]
  dockerfile = "docker/autoware/Dockerfile"
  target = "autoware"
}