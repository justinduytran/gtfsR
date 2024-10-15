#' @rdname realtime_VehiclePosition
#'
#' @export

realtime_Alert <- function(FeedMessage){

  entities <- FeedMessage$entity

  get_Alert_fields <- function(entity){
    data.frame(
      # Fields defined here by: https://gtfs.org/documentation/realtime/reference/#message-alert
      # Active period
      start = get_field(entity, "alert", "active_period") |>
        get_field_list("start"),
      end = get_field(entity, "alert", "active_period") |>
        get_field_list("end"),
      # Informed entity
      agency_id = get_field(entity, "alert", "informed_entity") |>
        get_field_list("agency_id"),
      route_id = get_field(entity, "alert", "informed_entity") |>
        get_field_list("route_id"),
      route_type = get_field(entity, "alert", "informed_entity") |>
        get_field_list("route_type"),
      direction_id = get_field(entity, "alert", "informed_entity") |>
        get_field_list("direction_id"), # Experimental
      stop_id = get_field(entity, "alert", "informed_entity") |>
        get_field_list("stop_id"),

      # TripDescriptor (inside informed entity)
      # In tests of various feeds this section seems to be unused and throws errors due to NULL returns
      # Have commented out for now

      # trip_id = get_field(entity, "alert", "informed_entity") |>
      #   get_field_list("trip", make_list = FALSE) |>
      #   get_field("trip_id"),
      # trip_route_id = get_field(entity, "alert", "informed_entity") |>
      #   get_field_list("trip", make_list = FALSE) |>
      #   get_field("route_id"),
      # trip_direction_id = get_field(entity, "alert", "informed_entity") |>
      #   get_field_list("trip", make_list = FALSE) |>
      #   get_field("direction_id"),
      # trip_start_time = get_field(entity, "alert", "informed_entity") |>
      #   get_field_list("trip", make_list = FALSE) |>
      #   get_field("start_time"),
      # trip_start_date = get_field(entity, "alert", "informed_entity") |>
      #   get_field_list("trip", make_list = FALSE) |>
      #   get_field("start_date"),
      # trip_schedule_relationship = get_field(entity, "alert", "informed_entity") |>
      #   get_field_list("trip", make_list = FALSE) |>
      #   get_field("schedule_relationship"),

      # Other
      cause = get_field(entity, "alert", "cause"),
      cause_detail_text = get_field(entity, "alert", "cause_detail", "translation") |>
        get_field_list("text"),
      cause_detail_language = get_field(entity, "alert", "cause_detail", "translation") |>
        get_field_list("language"),
      effect = get_field(entity, "alert", "effect"),
      effect_detail_text = get_field(entity, "alert", "effect_detail", "translation") |>
        get_field_list("text"),
      effect_detail_language = get_field(entity, "alert", "effect_detail", "translation") |>
        get_field_list("language"),
      url_text = get_field(entity, "alert", "url", "translation") |>
        get_field_list("text"),
      url_language = get_field(entity, "alert", "url", "translation") |>
        get_field_list("language"),
      header_text = get_field(entity, "alert", "header_text", "translation") |>
        get_field_list("text"),
      header_text_language = get_field(entity, "alert", "header_text", "translation") |>
        get_field_list("language"),
      description_text = get_field(entity, "alert", "description_text", "translation") |>
        get_field_list("text"),
      description_text_language = get_field(entity, "alert", "description_text", "translation") |>
        get_field_list("language"),
      tts_header_text = get_field(entity, "alert", "tts_header_text", "translation") |>
        get_field_list("text"),
      tts_header_text_language = get_field(entity, "alert", "tts_header_text", "translation") |>
        get_field_list("language"),
      tts_description_text = get_field(entity, "alert", "tts_description_text", "translation") |>
        get_field_list("text"),
      tts_description_text_language = get_field(entity, "alert", "tts_description_text", "translation") |>
        get_field_list("language"),
      severity_level = get_field(entity, "alert", "severity_level"),
      image_url = get_field(entity, "alert", "image","localized_image") |>
        get_field_list("url"),
      image_media_type = get_field(entity, "alert", "image","localized_image") |>
        get_field_list("media_type"),
      image_language = get_field(entity, "alert", "image","localized_image") |>
        get_field_list("language"),
      image_alternative_text = get_field(entity, "alert", "image_alternative_text", "translation") |>
        get_field_list("text"),
      image_alternative_language = get_field(entity, "alert", "image_alternative_text", "translation") |>
        get_field_list("language")
      )
  }
  field_dataframe <- lapply(entities, get_Alert_fields)
  return(field_dataframe)
}
