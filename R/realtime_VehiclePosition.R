#' Read a GTFS-Realtime feed
#'
#' Processes a GTFS-Realtime message into a list of data.frames. Can be an Alert, TripUpdate, or VehiclePosition feed.
#'
#' @param FeedMessage Message of type 'transit_realtime.FeedMessage'. Intended to be from \code{\link{read_gtfsrealtime}}.
#'
#' @details
#' Creates a data.frame() for each \code{transit_realtime.FeedEntity} comprising a column and corresponding value for each field that should be present. The fields vary depending on the feed type but are defined in the documentation at \url{https://gtfs.org/documentation/realtime/reference/}. Using the wrong function (e.g. \code{\link{realtime_VehiclePosition}} with a TripUpdate feed) will generally result in an almost  empty dataset.
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
      trip_id = entity$vehicle$trip$trip_id,
      route_id = entity$vehicle$trip$route_id,
      direction_id = entity$vehicle$trip$direction_id, # Experimental
      start_time = entity$vehicle$trip$start_time,
      start_date = entity$vehicle$trip$start_date,
      schedule_relationship = entity$vehicle$trip$schedule_relationship,
      # VehicleDescriptor
      vehicle_id = entity$vehicle$vehicle$id,
      vehicle_label = entity$vehicle$vehicle$label,
      license_plate = entity$vehicle$vehicle$license_plate,
      wheelchair_accessible = entity$vehicle$vehicle$wheelchair_accessible,
      # Position
      lat = entity$vehicle$position$latitude,
      lon = entity$vehicle$position$longitude,
      bearing = entity$vehicle$position$bearing,
      odometer = entity$vehicle$position$odometer,
      speed = entity$vehicle$position$speed,
      # Other
      current_stop_sequence = entity$vehicle$current_stop_sequence,
      stop_id = entity$vehicle$stop_id,
      current_status = entity$vehicle$current_status,
      timestamp = entity$vehicle$timestamp,
      congestion_level = entity$vehicle$congestion_level,
      occupancy_status = entity$vehicle$occupancy_status, # Experimental
      occupancy_percentage = entity$vehicle$occupancy_percentage, # Experimental
      # Carriage details # Experimental
      carriage_details_id = entity$vehicle$multi_carriage_details |>
        get_field_list("id"),
      carriage_details_label = entity$vehicle$multi_carriage_details |>
        get_field_list("label"),
      carriage_details_occupancy_status = entity$vehicle$multi_carriage_details |>
        get_field_list("occupancy_status"),
      carriage_details_occupancy_percentage = entity$vehicle$multi_carriage_details |>
        get_field_list("occupancy_percentage"),
      carriage_details_carriage_sequence = entity$vehicle$multi_carriage_details |>
        get_field_list("carriage_sequence")
    )
  }
    field_dataframe <- lapply(entities, get_VehiclePosition_fields)
    return(field_dataframe)
}
