
# gtfsrealtime

## Overview

`gtfsrealtime` is an R package for reading General Transit Feed
Specification Realtime (GTFS-Realtime) data into R.

## Installation

Install `gtfsrealtime` with:

``` r
remotes::install_github("justinduytran/gtfsrealtime")
```

## Usage

Reading GTFS-Realtime feeds into R requires a few steps:

**1. Make an API call from a GTFS-Realtime feed.**

This is not handled by this package and it is suggested to use `httr` or
`httr2` to obtain a webserver response, e.g.:

``` r
api_call <- api_url |>
  httr2::request() |>
  # If the api requires a key
  httr2::req_headers(Authorization = "your_api_key_here") |>
  httr2::req_method("GET") |>
  httr2::req_perform()
```

**2. Load the relevant GTFS-Realtime protocol buffer file.**

`load_gtfs_realtime_proto()` automatically loads the protocol buffer
file when the package is loaded. The package includes the required
.proto file from the GTFS-Realtime github.

**3. Read the binary data in the api_call to obtain the FeedMessage
using `read_gtfsrealtime()`.**

``` r
FeedMessage <- read_gtfsrealtime(api_call)
```

**4. Extract the relevant fields depending on the api feed.**

``` r
VehiclePosition <- realtime_VehiclePosition(FeedMessage)
TripUpdate <- realtime_TripUpdate(FeedMessage)
Alert <- realtime_Alert(FeedMessage)
```

NOTE: if the `api_url` is for a TripUpdate feed and you used
`realtime_VehiclePosition()` the resulting data will not throw an error
but return a mostly empty dataset. So ensure you use the right function.

It is also recommended to use `dplyr::bind_rows()` after the
`realtime_X()` function to convert the list of data.frames into one
data.frame.

**Worked example: Cairns (Queensland, Australia) Sunbus (now Kinetic)
TripUpdate feed**

``` r
sunbus_cairns_url <- "https://gtfsrt.api.translink.com.au/api/realtime/CNS/TripUpdates"

sunbus_cairns_api_call <- sunbus_cairns_url |>
  httr2::request() |>
  httr2::req_method("GET") |>
  httr2::req_perform()

sunbus_cairns_message <- sunbus_cairns_apicall |>
  read_gtfsrealtime()

sunbus_cairns <- sunbus_cairns_message |>
  realtime_TripUpdate() |>
  # Optional
  dplyr::bind_rows()

sunbus_cairns
```

**Only extracting certain fields**

The `realtime_X()` functions pulls all the fields that may be present in
each feed type as specified in
<https://gtfs.org/documentation/realtime/reference>. In some cases you
may only want a few fields to reduce processing time. For example in a
`VehiclePosition` feed, you may only want the latitude and longitude of
the present entities. If so, you can create a customised data.frame
suitable to your needs likeso:

``` r
# Assuming VehiclePosition feed
entities <- FeedMessage$entity

get_lat_lon <- function(entity){
    data.frame(
      lat = entity$vehicle$position$latitude,
      lon = entity$vehicle$position$latitude,
    )
}
lat_lon_data <- lapply(entities, get_lat_lon)
```

When a field consists of a list of values, use `get_field_list()`. For
example in a `TripUpdate` feed, `stop_id`, `arrival` and `departure`
times:

``` r
# Assuming TripUpdate feed
entities <- FeedMessage$entity

get_trip_stop_times <- function(entity){
    data.frame(
      stop_id = entity$trip_update$stop_time_update |>
        get_field_list("stop_id"),
      stop_arrival_time = entity$trip_update$stop_time_update |>
        get_field_list("arrival", "time"),
      stop_departure_time = entity$trip_update$stop_time_update |>
        get_field_list("departure", "time"),
    )
}
trip_stop_time_data <- lapply(entities, get_trip_stop_times)
```

`entity$trip_update$stop_time_update |> get_field_list("arrival", "time")`
is the same as `entity$trip_update$stop_time_update[[i]]$arrival$time"`
(for all i present)

## Bug reports, contributions and feedback

Please submit a GitHub issue if you come across any bugs. I’ve tested
the package on SydneyTrains GTFS-Realtime feeds and on a random sample
from <https://mobilitydatabase.org/> with no major problems (yet). Also
happy to take suggestions for improvement.
