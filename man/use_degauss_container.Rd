% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/use_degauss_files.R
\name{use_degauss_container}
\alias{use_degauss_container}
\alias{use_degauss_dockerfile}
\alias{use_degauss_makefile}
\alias{use_degauss_readme}
\alias{use_degauss_githook_readme_rmd}
\alias{use_degauss_entrypoint}
\alias{use_degauss_dockerignore}
\alias{use_degauss_tests}
\alias{use_degauss_license}
\alias{use_degauss_github_actions}
\title{use DeGAUSS container template}
\usage{
use_degauss_container(geomarker = getwd(), version = "0.1.0", ...)

use_degauss_dockerfile(geomarker = getwd(), version, ...)

use_degauss_makefile(geomarker = getwd(), ...)

use_degauss_readme(geomarker = getwd(), version = "0.1.0", ...)

use_degauss_githook_readme_rmd(geomarker = getwd(), ...)

use_degauss_entrypoint(geomarker = getwd(), version = "0.1.0", ...)

use_degauss_dockerignore(geomarker = getwd(), ...)

use_degauss_tests(geomarker = getwd(), ...)

use_degauss_license(geomarker = getwd(), ...)

use_degauss_github_actions(geomarker = getwd(), ...)
}
\arguments{
\item{geomarker}{path to folder where DeGAUSS container files are to be added;
defaults to the current working directory}

\item{version}{string of version number used in freshly created README and entrypoint.R; defaults to "0.1.0"}

\item{...}{arguments passed to render_degauss_template (overwrite)}
}
\description{
Creates all the necessary files to create a DeGAUSS container.
The container/geomarker name is assumed to be the basename of the working directory
and the version of R and renv is taken from the calling environment.
This function calls all of the individual \verb{dht::use_degauss_*()} functions to create the following:
\itemize{
\item \code{Dockerfile}
\item \code{Makefile}
\item \code{README.md}
\item \code{entrypoint.R}
\item \code{.dockerignore}
\item \code{test/my_address_file_geocoded.csv}
\item \code{LICENSE} GPL license
\item \code{.github/workflows/build-deploy-pr.yaml}
\item \code{.github/workflows/build-deploy-release.yaml}
}
}
