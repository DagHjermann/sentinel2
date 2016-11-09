#' Creates new or update existing regions of interest
#'
#' Place/Update roi for processing Sentinel-2 data
#'
#' @param geometry SpatialPoints, SpatialPolygons or path to a shapefile on disk
#' @param regionId character a new or existing region name
#' @param cloudCovMax integer cloud coverage treshold for a given region
#' @param dateMin character, date 'YYYY-MM-DD' beginning of the region's time span
#' @param dateMax character, date 'YYYY-MM-DD' end of the region's time span
#' @param indicators character vector of indicator names to be computed for a
#'   given region (e.g. \code{c("LAI", "FAPAR")})
#' @param srid integer geometry projection SRID (e.g. 4326 for WGS-84)
#' @return side effect of putting the roi supplied via 'geometry' to
#'   's2.boku.eodc.eu'
#' @export


S2_put_ROI <- function(geometry,
                       regionId    = NULL,
                       cloudCovMax = 50,
                       indicators  = NULL,
                       dateMin     = NULL,
                       dateMax     = NULL,
                       srid        = 4326){

  if (is.null(dateMin) || is.null(dateMax)){
    stop("Please supply 'dateMin' and 'dateMax' in format 'YYYY-MM-DD")
  }

  if (is.null(regionId)){
    stop("'regionId' not specified!",
         "\n-> If you want to update an existing 'roi', please supply valid 'regionId'",
         "\n-> If you like to create a new 'regionId' enter desired name")
  }

  geometry  <- roi_to_jgeom(geometry)

  body_l    <- list(cloudCovMax  = cloudCovMax,
                    dateMin      = dateMin,
                    dateMax      = dateMax,
                    geometry     = geometry,
                    srid         = srid)

  body_l   <- body_l[!sapply(body_l , is.null)]

  user     <- getOption("S2user")
  password <- getOption("S2password")
  rtrn     <- httr::PUT('https://s2.boku.eodc.eu',
                        config = httr::authenticate(user, password),
                        path   = list("roi", regionId),
                        body   = body_l)

  return(rtrn)

}