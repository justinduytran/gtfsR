#' @rdname realtime_VehiclePosition
#'
#' @export

realtime_TripUpdate <- function(FeedMessage){

  entities <- FeedMessage$entity

  get_TripUpdate_fields <- function(entity){
    data.frame(
      # Fields defined here by: https://gtfs.org/documentation/realtime/reference/#message-tripupdate
      # TripDescriptor
      trip_id = get_field(entity, "trip_update", "trip", "trip_id"),
      route_id = get_field(entity, "trip_update", "trip", "route_id"),
      direction_id = get_field(entity, "trip_update", "trip", "direction_id"), # Experimental
      start_time = get_field(entity, "trip_update", "trip", "start_time"),
      start_date = get_field(entity, "trip_update", "trip", "start_date"),
      schedule_relationship = get_field(entity, "trip_update", "trip", "schedule_relationship"),
      # VehicleDescriptor # OPTIONAL
      vehicle_id = get_field(entity, "trip_update", "vehicle", "id"),
      vehicle_label = get_field(entity, "trip_update", "vehicle", "label"),
      license_plate = get_field(entity, "trip_update", "vehicle", "license_plate"),
      wheelchair_accessible = get_field(entity, "trip_update", "vehicle", "wheelchair_accessible"),
      # StopTimeUpdate
      stop_sequence = get_field(entity, "trip_update", "stop_time_update") |>
        get_field_list("stop_sequence"),
      stop_id = get_field(entity, "trip_update", "stop_time_update") |>
        get_field_list("stop_id"),
      stop_departure_occupancy_status = get_field(entity, "trip_update", "stop_time_update")  |>
        get_field_list("departure_occupancy_status"), # Experimental
      stop_schedule_relationship = get_field(entity, "trip_update", "stop_time_update") |>
        get_field_list("schedule_relationship"),
      stop_assigned_stop_id = get_field(entity, "trip_update", "stop_time_update") |>
        get_field_list("stop_time_properties", "assigned_stop_id"), # Experimental
      # StopTimeEvent (inside StopTimeUpdate)
      stop_arrival_delay = get_field(entity, "trip_update", "stop_time_update") |>
        get_field_list("arrival", "delay"),
      stop_arrival_time = get_field(entity, "trip_update", "stop_time_update") |>
        get_field_list("arrival", "time"),
      stop_arrival_uncertainty = get_field(entity, "trip_update", "stop_time_update") |>
        get_field_list("arrival", "uncertainty"),
      stop_departure_delay = get_field(entity, "trip_update", "stop_time_update") |>
        get_field_list("departure", "delay"),
      stop_departure_time = get_field(entity, "trip_update", "stop_time_update") |>
        get_field_list("departure", "time"),
      stop_departure_uncertainty = get_field(entity, "trip_update", "stop_time_update") |>
        get_field_list("departure", "uncertainty"),
      # Other
      timestamp = get_field(entity, "trip_update", "timestamp"),
      delay = get_field(entity, "trip_update", "delay"), # Experimental
      # TripProperties # EXPERIMENTAL
      trip_id_property = get_field(entity, "trip_update", "trip_properties", "trip_id"),
      start_date_property = get_field(entity, "trip_update", "trip_properties", "start_date"),
      start_time_property = get_field(entity, "trip_update", "trip_properties", "start_time"),
      shape_id_property = get_field(entity, "trip_update", "trip_properties", "shape_id")
    )
  }
  field_dataframe <- lapply(entities, get_TripUpdate_fields)
  return(field_dataframe)
}
