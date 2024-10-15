#' Read a gtfs-realtime feed
#'
#' Processes a gtfs-realtime message into a list of data.frames. Can be Alert, TripUpdate, or VehiclePosition feed.
#'
#' @param FeedMessage Message of type 'transit_realtime.FeedMessage'. Intended to be from \code{\link{read_gtfsrealtime}}.
#'
#' @details
#' Creates a data.frame() defined by a preset template of \code{\link{get_field}} and \code{\link{get_field_list}}s for each feed as set out by \url{https://gtfs.org/documentation/realtime/reference/}. It iterates over \code{transit_realtime.FeedEntity} and returns them all in a separate row in a data.frame. Using the wrong function (e.g. \code{\link{realtime_VehiclePosition}} with a TripUpdate feed) will generally result in a largely empty dataset.
#'
#' @returns List of data.frames.
#'
#' @examples
#' \dontrun{
#'
#' # Generic GTFS-realtime VehiclePosition feed
#' api_call |>
#'   read_gtfsrealtime() |>
#'   realtime_VehiclePosition() |>
#'   # Optional, but recommended
#'   dplyr::bind_rows()
#'
#' # Cairns SunBus (api currently does not require registration)
#'
#' sunbus_cairns_url <- "https://gtfsrt.api.translink.com.au/api/realtime/CNS/TripUpdates"
#'
#' sunbus_cairns_api_call <- sunbus_cairns_url |>
#'   httr2::request() |>
#'   httr2::req_method("GET") |>
#'   httr2::req_perform()
#'
#' sunbus_cairns_message <- sunbus_cairns_apicall |>
#'   read_gtfsrealtime()
#'
#' sunbus_cairns <- sunbus_cairns_message |>
#'   realtime_TripUpdate() |>
#'   dplyr::bind_rows()
#'
#' sunbus_cairns
#' }
#' @export

realtime_VehiclePosition <- function(FeedMessage){

  entities <- FeedMessage$entity

  get_VehiclePosition_fields <- function(entity){
    data.frame(
      # Fields defined here by: https://gtfs.org/documentation/realtime/reference/#message-vehicleposition
      # TripDescriptor
      trip_id = get_field(entity, "vehicle", "trip", "trip_id"),
      route_id = get_field(entity, "vehicle", "trip", "route_id"),
      direction_id = get_field(entity, "vehicle", "trip", "direction_id"), # Experimental
      start_time = get_field(entity, "vehicle", "trip", "start_time"),
      start_date = get_field(entity, "vehicle", "trip", "start_date"),
      schedule_relationship = get_field(entity, "vehicle", "trip", "schedule_relationship"),
      # VehicleDescriptor
      vehicle_id = get_field(entity, "vehicle", "vehicle", "id"),
      vehicle_label = get_field(entity, "vehicle", "vehicle", "label"),
      license_plate = get_field(entity, "vehicle", "vehicle", "license_plate"),
      wheelchair_accessible = get_field(entity, "vehicle", "vehicle", "wheelchair_accessible"),
      # Position
      lat = get_field(entity, "vehicle", "position", "latitude"),
      lon = get_field(entity, "vehicle", "position", "longitude"),
      bearing = get_field(entity, "vehicle", "position", "bearing"),
      odometer = get_field(entity, "vehicle", "position", "odometer"),
      speed = get_field(entity, "vehicle", "position", "speed"),
      # Other
      current_stop_sequence = get_field(entity, "vehicle", "current_stop_sequence"),
      stop_id = get_field(entity, "vehicle", "stop_id"),
      current_status = get_field(entity, "vehicle", "current_status"),
      timestamp = get_field(entity, "vehicle", "timestamp"),
      congestion_level = get_field(entity, "vehicle", "congestion_level"),
      occupancy_status = get_field(entity, "vehicle", "occupancy_status"), # Experimental
      occupancy_percentage = get_field(entity, "vehicle", "occupancy_percentage"), # Experimental
      # Carriage details # Experimental
      carriage_details_id = get_field(entity, "vehicle", "multi_carriage_details") |>
        get_field_list("id"),
      carriage_details_label = get_field(entity, "vehicle", "multi_carriage_details") |>
        get_field_list("label"),
      carriage_details_occupancy_status = get_field(entity, "vehicle", "multi_carriage_details") |>
        get_field_list("occupancy_status"),
      carriage_details_occupancy_percentage = get_field(entity, "vehicle", "multi_carriage_details") |>
        get_field_list("occupancy_percentage"),
      carriage_details_carriage_sequence = get_field(entity, "vehicle", "multi_carriage_details") |>
        get_field_list("carraige_sequence")
    )
  }
    field_dataframe <- lapply(entities, get_VehiclePosition_fields)
    return(field_dataframe)
}
