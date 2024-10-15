#' Load gtfs-realtime .proto file
#'
#' Loads Descriptors from the gtfs-realtime.proto file.
#'
#' @details
#' Runs upon package load. This should only be need to be run again if the Descriptor pool has been reset through \code{\link[RProtoBuf]{resetDescriptorPool}} or some other way.
#'
#' @importFrom RProtoBuf readProtoFiles
#'
#' @export

load_gtfs_realtime_proto <- function(){
  # Find package directory and prepare proto directory
  package_directory <- system.file(package = "gtfsR", mustWork = TRUE)
  proto_directory <- file.path(package_directory, "proto")
  proto_path <- file.path(proto_directory, "gtfs-realtime.proto")

  # Load the Descriptors
  RProtoBuf::readProtoFiles(proto_path)
}
