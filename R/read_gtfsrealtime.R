#' Parse GTFS-Realtime feeds
#'
#' Takes a GTFS-Realtime feed api call and translates the binary data to a \code{RProtoBuf} message.
#'
#' @param api_request httr or httr2 GET call
#'
#' @returns message of type 'transit_realtime.FeedMessage'
#'
#' @details
#' Currently only supports \code{httr} and \code{httr2} responses.
#'
#' @examples
#' \dontrun{
#'
#' # Cairns SunBus (api currently does not require registration)
#' sunbus_cairns_url <- "https://gtfsrt.api.translink.com.au/api/realtime/CNS/TripUpdates"
#'
#' sunbus_cairns_api_call <- sunbus_cairns_url |>
#'   httr2::request() |>
#'   httr2::req_method("GET") |>
#'   httr2::req_perform()
#'
#' sunbus_cairns_message <- sunbus_cairns_api_call |>
#'   read_gtfsrealtime()
#'
#' sunbus_cairns_message
#' }
#' @importFrom RProtoBuf read
#'
#' @export

read_gtfsrealtime <- function(api_request) {
  validate_bin_path <- function(x) {
    switch(
      class(x),
      # httr calls
      "response" = x$content,
      # httr2 calls
      "httr2_response" = x$body,
      # Else
      message("Error: Unknown response type")
    )
  }
  bin_path <- validate_bin_path(api_request)
  bin <- readBin(bin_path, raw(0), length(bin_path))

  FeedMessage <- RProtoBuf::read(transit_realtime.FeedMessage, bin)

  return(FeedMessage)
}
