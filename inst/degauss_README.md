# {{{name}}} <a href='https://degauss-org.github.io/DeGAUSS/'><img src='https://github.com/degauss-org/degauss_template/raw/master/DeGAUSS_hex.png' align='right' height='138.5' /></a>

> {insert brief description of {{{name}}} here}
[![Docker Build Status](https://img.shields.io/docker/automated/degauss/{{{name}}})](https://hub.docker.com/repository/docker/degauss/{{{name}}}/tags)
[![GitHub Latest Tag](https://img.shields.io/github/v/tag/degauss-org/{{{name}}})](https://github.com/degauss-org/{{{name}}}/releases)

## DeGAUSS example call

If `my_address_file_geocoded.csv` is a file in the current working directory with coordinate columns named `lat` and `lon`, then

```sh
docker run --rm -v $PWD:/tmp /degauss/{{{name}}}:{{{version}}} my_address_file_geocoded.csv
```

will produce `my_address_file_geocoded_{{{name}}}_v{{{version}}}.csv` with an added column named {{{name}}}.

## geomarker methods

- if any non-trivial methods were developed for geomarker assessment (i.e. inverse distance weighted averaging), then describe them here

## geomarker data

- list how geomarker was created, including any scripts within the repo used to do so
- list where geomarker data is stored in S3 using a hyperlink like: [`s3://path/to/{{{name}}}.rds`](https://geomarker.s3.us-east-2.amazonaws.com/path/to/paste_geomarker_name_here.rds)

## DeGAUSS details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS homepage](https://degauss.org).
