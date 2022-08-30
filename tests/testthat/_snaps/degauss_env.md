# can get degauss metadata from online dockerfile

    Code
      get_degauss_env_online("fortunes")
    Output
                                  degauss_name 
                                    "fortunes" 
                               degauss_version 
                                       "0.1.3" 
                           degauss_description 
                               "random quotes" 
                              degauss_argument 
      "number of quotes to print [default: 1]" 

# can get degauss metadata online for core library

    Code
      as.data.frame(suppressMessages(get_degauss_core_lib_env()))
    Output
               degauss_name degauss_version
      1            geocoder           3.2.1
      2  census_block_group           0.6.0
      3           dep_index           0.2.1
      4          greenspace           0.3.0
      5               roads           0.2.1
      6                aadt           0.2.0
      7                nlcd           0.2.0
      8           drivetime           1.1.0
      9     st_census_tract           0.2.1
      10                 pm           0.2.0
      11               narr           0.4.0
                                       degauss_description
      1                                           geocodes
      2                       census block group and tract
      3               census tract-level deprivation index
      4                          enhanced vegetation index
      5                proximity and length of major roads
      6                       average annual daily traffic
      7   land cover (imperviousness, land use, greenness)
      8              distance and drive time to care sites
      9  census tract identifiers with appropriate vintage
      10                                       daily PM2.5
      11   daily weather data (temperature, humidity, etc)
                                                                                         degauss_argument
      1                                                      valid_geocode_score_threshold [default: 0.5]
      2                                                                       census year [default: 2010]
      3                                                                                              <NA>
      4                                                                                              <NA>
      5                                                            buffer radius in meters [default: 400]
      6                                                            buffer radius in meters [default: 400]
      7                                                            buffer radius in meters [default: 400]
      8                                                                         care_site [default: none]
      9                                                                                              <NA>
      10                                                                                             <NA>
      11 NARR variables to be returned (weather, wind, atmosphere, pratepres, or none) [default: weather]

---

    Code
      as.data.frame(suppressMessages(get_degauss_core_lib_env(geocoder = FALSE)))
    Output
               degauss_name degauss_version
      1  census_block_group           0.6.0
      2           dep_index           0.2.1
      3          greenspace           0.3.0
      4               roads           0.2.1
      5                aadt           0.2.0
      6                nlcd           0.2.0
      7           drivetime           1.1.0
      8     st_census_tract           0.2.1
      9                  pm           0.2.0
      10               narr           0.4.0
                                       degauss_description
      1                       census block group and tract
      2               census tract-level deprivation index
      3                          enhanced vegetation index
      4                proximity and length of major roads
      5                       average annual daily traffic
      6   land cover (imperviousness, land use, greenness)
      7              distance and drive time to care sites
      8  census tract identifiers with appropriate vintage
      9                                        daily PM2.5
      10   daily weather data (temperature, humidity, etc)
                                                                                         degauss_argument
      1                                                                       census year [default: 2010]
      2                                                                                              <NA>
      3                                                                                              <NA>
      4                                                            buffer radius in meters [default: 400]
      5                                                            buffer radius in meters [default: 400]
      6                                                            buffer radius in meters [default: 400]
      7                                                                         care_site [default: none]
      8                                                                                              <NA>
      9                                                                                              <NA>
      10 NARR variables to be returned (weather, wind, atmosphere, pratepres, or none) [default: weather]

