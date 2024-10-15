#' Read transit_realtime.FeedMessage field with "Many" cardinality
#'
#' Reads the field when its cardinality is "Many" (>1), requiring the output to be a list.
#'
#' @param message_list A list of fields containing messages with identical type / number of fields set. Example field types include "StopTimeUpdate" and "TranslatedString".
#' @param ... A sequence of strings specifying the "path" to the desired field.
#'
#' @details
#' See \url{https://gtfs.org/documentation/realtime/reference} for relevant fields with "Many" cardinality.
#'
#' @returns A list of the content of the specified field corresponding to each message.
#'
#' @examples
#' \dontrun{
#'
#' # Generic code
#' FeedMessage <- read_gtfsrealtime(api_call)
#'
#' # Assuming a TripUpdate FeedMessage:
#'
#' # First obtain the field with "Many" cardinality
#' # In this case a message of type 'transit_realtime.TripUpdate.StopTimeUpdate'
#' field <- get_field(FeedMessage$entity[[1]], "trip_update", "stop_time_update")
#'
#' # Then return the list of specified field for a single entity
#' # When the desired field ("stop_sequence") is a field under "stop_time_update"
#' get_field_list(field, "stop_sequence")
#' # When the desired field ("time") is a field in the "arrival" field under "stop_time_update"
#' get_field_list(field, "arrival", "time")
#'
#' # This whole sequence can be piped:
#' get_field(FeedMessage$entity[[1]], "trip_update", "stop_time_update") |>
#'   get_field_list(field, "arrival", "time")
#' # and is the same as:
#' FeedMessage$entity[[1]]$trip_update$stop_time_update[[i]]$arrival$time
#' }
#' @export

get_field_list <- function(message_list, ...) {
  fields <- list(...)
  lapply(message_list, function(x) {
    field <- x
    for (i in fields) {
      field <- field[[i]]
    }
    field
  }) |>
    list() |>
    I()
}
