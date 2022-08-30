# create degauss menu data

    Code
      as.data.frame(suppressMessages(create_degauss_menu_data()))
    Output
                       name version                                       description
      1            geocoder   3.2.1                                          geocodes
      2  census_block_group   0.6.0                      census block group and tract
      3           dep_index   0.2.1              census tract-level deprivation index
      4          greenspace   0.3.0                         enhanced vegetation index
      5               roads   0.2.1               proximity and length of major roads
      6                aadt   0.2.0                      average annual daily traffic
      7                nlcd   0.2.0  land cover (imperviousness, land use, greenness)
      8           drivetime   1.1.0             distance and drive time to care sites
      9     st_census_tract   0.2.1 census tract identifiers with appropriate vintage
      10                 pm   0.2.0                                       daily PM2.5
      11               narr   0.4.0   daily weather data (temperature, humidity, etc)
                                                                              argument
      1                                                  valid_geocode_score_threshold
      2                                                                    census year
      3                                                                           <NA>
      4                                                                           <NA>
      5                                                        buffer radius in meters
      6                                                        buffer radius in meters
      7                                                        buffer radius in meters
      8                                                                      care_site
      9                                                                           <NA>
      10                                                                          <NA>
      11 NARR variables to be returned (weather, wind, atmosphere, pratepres, or none)
         argument_default                                    url
      1               0.5           https://degauss.org/geocoder
      2              2010 https://degauss.org/census_block_group
      3              <NA>          https://degauss.org/dep_index
      4              <NA>         https://degauss.org/greenspace
      5               400              https://degauss.org/roads
      6               400               https://degauss.org/aadt
      7               400               https://degauss.org/nlcd
      8              none          https://degauss.org/drivetime
      9              <NA>    https://degauss.org/st_census_tract
      10             <NA>                 https://degauss.org/pm
      11          weather               https://degauss.org/narr
                                                                                                         degauss_cmd
      1             docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/geocoder:3.2.1 my_address_file_geocoded.csv 0.5
      2  docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/census_block_group:0.6.0 my_address_file_geocoded.csv 2010
      3                docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/dep_index:0.2.1 my_address_file_geocoded.csv
      4               docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/greenspace:0.3.0 my_address_file_geocoded.csv
      5                docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/roads:0.2.1 my_address_file_geocoded.csv 400
      6                 docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/aadt:0.2.0 my_address_file_geocoded.csv 400
      7                 docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/nlcd:0.2.0 my_address_file_geocoded.csv 400
      8           docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/drivetime:1.1.0 my_address_file_geocoded.csv none
      9          docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/st_census_tract:0.2.1 my_address_file_geocoded.csv
      10                      docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/pm:0.2.0 my_address_file_geocoded.csv
      11            docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/narr:0.4.0 my_address_file_geocoded.csv weather

