#' @title clean_emdat
#'
#' @description This data contains the disasters reported by EMDAT with cleaned
#'              geography and dates.
#' @docType data
#'
#' @usage data(clean_emdat)
#'
#' @format A tibble with
#' \describe{
#'   \item{Source}{The origin from the data comes, in this case EMDAT}
#'   \item{event_id}{The original ID given by EMDAT to each disaster}
#'   \item{region_id}{The original ID given by EMDAT to each disaster identifying county}
#'   \item{state}{USA State}
#'   \item{county}{USA county within state}
#'   \item{Day}{Date format that contains the month, day and year of an event}
#'   \item{incident_type}{The category of the disaster reported}
#'   \item{nkill}{Number of people killed}
#'   \item{nwound}{Number of people wounded}
#'   }
"clean_emdat"
