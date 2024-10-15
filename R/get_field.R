#' Read transit_realtime.FeedEntity field
#'
#' Reads the desired field from a \code{transit_realtime.FeedEntity} message.
#'
#' @param FeedEntity The \code{transit_realtime.FeedEntity}. Intended to be an element of \code{read_gtfsrealtime()$entity}
#' @param ... A sequence of strings specifying "path" to the desired field. E.g. "vehicle", "trip", "route_id" would be equivalent to \code{transit_realtime.FeedEntity$vehicle$trip$route_id}
#'
#' @returns The content of the specified field.
#'
#' @details
#' #' See \url{https://gtfs.org/documentation/realtime/reference} for field documentation.
#'
#' @examples
#' \dontrun{
#'
#' # Generic GTFS-realtime feed
#' FeedMessage <- read_gtfsrealtime(api_call)
#'
#' # Assuming a VehiclePosition FeedMessage:
#' # Return a given field for the first entity
#' get_field(FeedMessage$entity[[1]], "vehicle", "trip", "route_id")
#' # Note this is the same as:
#' FeedMessage$entity[[1]]$vehicle$trip$route_id
#'
#' # Return a given field for all present entities
#' entities <- FeedMessage$entity
#' lapply(entities, get_field, "vehicle", "trip", "route_id")
#' }
#' @export

get_field <- function(FeedEntity, ...) {
  fields <- list(...)
  returned_field <- Reduce(function(x, field) x[[field]], fields, init = FeedEntity)
  return(returned_field)
}
