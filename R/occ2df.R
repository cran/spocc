#' Combine results from occ calls to a single data.frame
#'
#' @export
#'
#' @param obj Input from occ, an object of class `occdat`, or an object
#' of class `occdatind`, the individual objects from each source within the
#' `occdat` class.
#' @param what (character) One of data (default) or all (with metadata)
#'
#' @details
#' This function combines a subset of data from each data provider to a single
#' data.frame, or metadata plus data if you request `what="all"`. The
#' single data.frame contains the following columns:
#'
#' - name - scientific (or common) name
#' - longitude - decimal degree longitude
#' - latitude - decimal degree latitude
#' - prov - data provider
#' - date - occurrence record date
#' - key - occurrence record key
#'
#' @examples \dontrun{
#' # combine results from output of an occ() call
#' spnames <- c('Accipiter striatus', 'Setophaga caerulescens',
#'   'Spinus tristis')
#' out <- occ(query=spnames, from='gbif', gbifopts=list(hasCoordinate=TRUE),
#'   limit=10)
#' occ2df(out)
#' occ2df(out$gbif)
#'
#' out <- occ(
#'   query='Accipiter striatus',
#'   from=c('gbif','ebird','inat'),
#'   gbifopts=list(hasCoordinate=TRUE), limit=2)
#' occ2df(out)
#' occ2df(out$gbif)
#'
#' # or combine many results from a single data source
#' spnames <- c('Accipiter striatus', 'Spinus tristis')
#' out <- occ(query=spnames, from='gbif', limit=2)
#' occ2df(out$gbif)
#' }
occ2df <- function(obj, what = "data") {
  UseMethod("occ2df")
}

#' @export
occ2df.occdatind <- function(obj, what = "data") {
  as_tibble(rbind_fill(obj$data))
}

foolist <- function(x) {
  if (is.null(x)) {
    data.frame(NULL)
  } else {
    do.call(rbind_fill, x$data)
  }
}

#' @export
occ2df.occdat <- function(obj, what = "data") {
  what <- match.arg(what, choices = c("all", "data"))
  aa <- foolist(obj$gbif)
  cc <- foolist(obj$inat)
  dd <- foolist(obj$ebird)
  vn <- foolist(obj$vertnet)
  id <- foolist(obj$idigbio)
  ob <- foolist(obj$obis)
  ala <- foolist(obj$ala)
  tmp <- rbind_fill(
    Map(
      function(x, y){
        if (NROW(x) == 0) {
          tibble()
        } else {
          dat <- x[ , c('name', 'longitude', 'latitude', 'prov',
                        pluck_fill(x, datemap[[y]]),
                        pluck_fill(x, keymap[[y]])) ]
          if (is.null(datemap[[y]])) {
            dat$date <- as.Date(rep(NA_character_, NROW(dat)))
          } else {
            dat <- rename(dat, stats::setNames("date", datemap[[y]]),
                          warn_missing = FALSE)
          }
          rename(dat, stats::setNames("key", keymap[[y]]))
        }
      },
      list(aa, cc, dd, vn, id, ob, ala),
      c('gbif','inat','ebird',
        'vertnet','idigbio','obis','ala')
    )
  )
  tmpout <- list(
    meta = list(obj$gbif$meta, obj$inat$meta,
                obj$ebird$meta, obj$vn$meta, obj$id$meta,
                obj$ob$meta, obj$ala$meta),
    data = tmp
  )
  if (what %in% "data") as_tibble(tmpout$data) else tmpout
}

datemap <- list(gbif = 'eventDate', inat = 'observed_on',
                ebird = 'obsDt', vertnet = "eventdate",
                idigbio = "eventDate", obis = "eventDate",
                ala = "eventDate")

keymap <- list(gbif = "key", inat = "id",
               ebird = "locID", vertnet = "occurrenceid", idigbio = "uuid",
               obis = "id", ala = "uuid")
