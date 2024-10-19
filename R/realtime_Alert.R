#' @rdname realtime_VehiclePosition
#'
#' @export

realtime_Alert <- function(FeedMessage){

  entities <- FeedMessage$entity

  get_Alert_fields <- function(entity){
    data.frame(
      # Fields defined here by: https://gtfs.org/documentation/realtime/reference/#message-alert
      # Active period
      start = entity[["alert"]][["active_period"]] |>
        get_field_list("start"),
      end = entity[["alert"]][["active_period"]] |>
        get_field_list("end"),
      # Informed entity
      agency_id = entity[["alert"]][["informed_entity"]] |>
        get_field_list("agency_id"),
      route_id = entity[["alert"]][["informed_entity"]] |>
        get_field_list("route_id"),
      route_type = entity[["alert"]][["informed_entity"]] |>
        get_field_list("route_type"),
      direction_id = entity[["alert"]][["informed_entity"]] |>
        get_field_list("direction_id"), # Experimental
      stop_id = entity[["alert"]][["informed_entity"]] |>
        get_field_list("stop_id"),

      # TripDescriptor (inside informed entity)
      # In tests of various feeds this section seems to be unused and throws errors due to NULL returns
      # Have commented out for now - (will need to change get_field() functionality if reinstated)

      trip_id = entity[["alert"]][["informed_entity"]] |>
        get_field_list("trip", make_list = FALSE) |>
        get_field("trip_id"),
      trip_route_id = entity[["alert"]][["informed_entity"]] |>
        get_field_list("trip", make_list = FALSE) |>
        get_field("route_id"),
      trip_direction_id = entity[["alert"]][["informed_entity"]] |>
        get_field_list("trip", make_list = FALSE) |>
        get_field("direction_id"),
      trip_start_time = entity[["alert"]][["informed_entity"]] |>
        get_field_list("trip", make_list = FALSE) |>
        get_field("start_time"),
      trip_start_date = entity[["alert"]][["informed_entity"]] |>
        get_field_list("trip", make_list = FALSE) |>
        get_field("start_date"),
      trip_schedule_relationship = entity[["alert"]][["informed_entity"]] |>
        get_field_list("trip", make_list = FALSE) |>
        get_field("schedule_relationship"),

      # Other
      cause = entity[["alert"]][["cause"]],
      cause_detail_text = entity[["alert"]][["cause_detail"]][["translation"]] |>
        get_field_list("text"),
      cause_detail_language = entity[["alert"]][["cause_detail"]][["translation"]] |>
        get_field_list("language"),
      effect = entity[["alert"]][["effect"]],
      effect_detail_text = entity[["alert"]][["effect_detail"]][["translation"]] |>
        get_field_list("text"),
      effect_detail_language = entity[["alert"]][["effect_detail"]][["translation"]] |>
        get_field_list("language"),
      url_text = entity[["alert"]][["url"]][["translation"]] |>
        get_field_list("text"),
      url_language = entity[["alert"]][["url"]][["translation"]] |>
        get_field_list("language"),
      header_text = entity[["alert"]][["header_text"]][["translation"]] |>
        get_field_list("text"),
      header_text_language = entity[["alert"]][["header_text"]][["translation"]] |>
        get_field_list("language"),
      description_text = entity[["alert"]][["description_text"]][["translation"]] |>
        get_field_list("text"),
      description_text_language = entity[["alert"]][["description_text"]][["translation"]] |>
        get_field_list("language"),
      tts_header_text = entity[["alert"]][["tts_header_text"]][["translation"]] |>
        get_field_list("text"),
      tts_header_text_language = entity[["alert"]][["tts_header_text"]][["translation"]] |>
        get_field_list("language"),
      tts_description_text = entity[["alert"]][["tts_description_text"]][["translation"]] |>
        get_field_list("text"),
      tts_description_text_language = entity[["alert"]][["tts_description_text"]][["translation"]] |>
        get_field_list("language"),
      severity_level = entity[["alert"]][["severity_level"]],
      image_url = entity[["alert"]][["image"]][["localized_image"]] |>
        get_field_list("url"),
      image_media_type = entity[["alert"]][["image"]][["localized_image"]] |>
        get_field_list("media_type"),
      image_language = entity[["alert"]][["image"]][["localized_image"]] |>
        get_field_list("language"),
      image_alternative_text = entity[["alert"]][["image_alternative_text"]][["translation"]] |>
        get_field_list("text"),
      image_alternative_language = entity[["alert"]][["image_alternative_text"]][["translation"]] |>
        get_field_list("language")
      )
  }
  field_dataframe <- lapply(entities, get_Alert_fields)
  return(field_dataframe)
}
