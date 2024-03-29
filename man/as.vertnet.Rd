% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/as.vertnet.R
\name{as.vertnet}
\alias{as.vertnet}
\title{Coerce occurrence keys to vertnetkey/occkey objects}
\usage{
as.vertnet(x)
}
\arguments{
\item{x}{Various inputs, including the output from a call to \code{\link[=occ]{occ()}}
(class occdat), \code{\link[=occ2df]{occ2df()}} (class data.frame), or a list, numeric,
character, vertnetkey, or occkey.}
}
\value{
One or more in a list of both class vertnetkey and occkey
}
\description{
Coerce occurrence keys to vertnetkey/occkey objects
}
\details{
Internally, we use \code{\link[rvertnet:vert_id]{rvertnet::vert_id()}}, whereas \code{\link[=occ]{occ()}}
uses \code{\link[rvertnet:vertsearch]{rvertnet::vertsearch()}}.
}
\examples{
\dontrun{
# spnames <- c('Accipiter striatus', 'Setophaga caerulescens',
#   'Spinus tristis')
# out <- occ(query=spnames, from='vertnet', has_coords=TRUE, limit=2)
# res <- occ2df(out)
# (tt <- as.vertnet(out))
# (uu <- as.vertnet(res))
# keys <- Filter(Negate(is.na), res$key)
# as.vertnet(keys[1])
# as.vertnet(as.list(keys[1:2]))
# as.vertnet(tt[[1]])
# as.vertnet(uu[[1]])
# as.vertnet(tt[1:2])
}
}
\seealso{
Other coercion: 
\code{\link{as.ala}()},
\code{\link{as.gbif}()},
\code{\link{as.idigbio}()},
\code{\link{as.inat}()},
\code{\link{as.obis}()}
}
\concept{coercion}
