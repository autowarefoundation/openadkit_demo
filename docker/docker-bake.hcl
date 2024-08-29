group "default" {
  targets = ["planning-control", "simulator", "visualizer"]
}

// For docker/metadata-action
target "docker-metadata-action-planning-control" {}
target "docker-metadata-action-simulator" {}
target "docker-metadata-action-visualizer" {}

target "planning-control" {
  inherits = ["docker-metadata-action-planning-control"]
  dockerfile = "docker/modules/planning-control/Dockerfile"
  target = "planning-control"
}

target "simulator" {
  inherits = ["docker-metadata-action-simulator"]
  dockerfile = "docker/modules/simulator/Dockerfile"
  target = "simulator"
}

target "visualizer" {
  inherits = ["docker-metadata-action-visualizer"]
  dockerfile = "docker/modules/visualizer/Dockerfile"
  target = "visualizer"
}
