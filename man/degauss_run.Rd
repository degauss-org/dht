% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/degauss_run.R
\name{degauss_run}
\alias{degauss_run}
\title{run a DeGAUSS container}
\usage{
degauss_run(.x, image, version = "latest", argument = NA, quiet = FALSE)
}
\arguments{
\item{.x}{a data.frame or tibble to be input to a DeGAUSS container}

\item{image}{name of DeGAUSS image}

\item{version}{version of DeGAUSS image; will use latest version if not specified}

\item{argument}{optional argument}

\item{quiet}{suppress output from DeGAUSS container?}
}
\value{
\code{.x} with additional returned DeGAUSS columns
}
\description{
This function uses temporary CSV files and DeGAUSS commands
as system calls to \code{docker}. Because of this approach,
caching of geocoding results or reuse of intermediate downloaded data
files are not possible, \emph{unless called from the same R session.} See
the examples for a workaround.
}
\examples{
## create a memoised version of degauss_run so repetitive calls are cached
## this can be useful during development of DeGAUSS pipelines
\dontrun{
fc <- memoise::cache_filesystem(fs::path(fs::path_wd(), "data-raw"))
degauss_run <- memoise::memoise(degauss_run, omit_args = c("quiet"), cache = fc)
}
}
