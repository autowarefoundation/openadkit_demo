group "default" {
  targets = [
    "simulator",
    "planning-control",
    "visualizer"
  ]
}

target "docker-metadata-action-simulator" {}
target "docker-metadata-action-planning-control" {}
target "docker-metadata-action-visualizer" {}

target "visualizer" {
  inherits = ["docker-metadata-action-visualizer"]
  dockerfile = "docker/Dockerfile"
  target = "visualizer"
}

target "simulator" {
  inherits = ["docker-metadata-action-simulator"]
  dockerfile = "docker/Dockerfile"
  target = "simulator"
}

target "planning-control" {
  inherits = ["docker-metadata-action-planning-control"]
  dockerfile = "docker/Dockerfile"
  target = "planning-control"
}
