% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/check_dates.R
\name{check_end_after_start_date}
\alias{check_end_after_start_date}
\title{check that end_date occurs after start_date}
\usage{
check_end_after_start_date(start_date, end_date)
}
\arguments{
\item{start_date}{vector of start dates}

\item{end_date}{vector of end dates}
}
\description{
check that end_date occurs after start_date
}
\examples{
\dontrun{
start_date <- check_dates(c("1/1/21", "1/2/21", "1/3/21"))
end_date <- check_dates(c("1/7/21", "1/8/21", "1/9/20"))
check_end_after_start_date(start_date, end_date)
}
}
