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
      suppressMessages(get_core_images())
    Output
      # A tibble: 11 x 4
         degauss_name       degauss_version degauss_description       degauss_argument
         <chr>              <chr>           <chr>                     <chr>           
       1 geocoder           3.2.0           geocodes                  valid_geocode_s~
       2 census_block_group 0.5.1           census block group and t~ census year [de~
       3 st_census_tract    0.2.0           census tract identifiers~ <NA>            
       4 dep_index          0.2.0           census tract-level depri~ <NA>            
       5 roads              0.2.1           proximity and length of ~ buffer radius i~
       6 aadt               0.2.0           average annual daily tra~ buffer radius i~
       7 greenspace         0.3.0           enhanced vegetation index <NA>            
       8 nlcd               0.2.0           land cover (imperviousne~ buffer radius i~
       9 pm                 0.2.0           daily PM2.5               <NA>            
      10 narr               0.3.0           daily weather data (temp~ optional --all ~
      11 drivetime          1.1.0           distance and drive time ~ care_site [defa~

---

    Code
      suppressMessages(get_core_images(badges = TRUE))
    Output
      # A tibble: 11 x 7
         degauss_name       degauss_version degauss_description degauss_argument url  
         <chr>              <chr>           <chr>               <chr>            <glu>
       1 geocoder           3.2.0           geocodes            valid_geocode_s~ http~
       2 census_block_group 0.5.1           census block group~ census year [de~ http~
       3 st_census_tract    0.2.0           census tract ident~ <NA>             http~
       4 dep_index          0.2.0           census tract-level~ <NA>             http~
       5 roads              0.2.1           proximity and leng~ buffer radius i~ http~
       6 aadt               0.2.0           average annual dai~ buffer radius i~ http~
       7 greenspace         0.3.0           enhanced vegetatio~ <NA>             http~
       8 nlcd               0.2.0           land cover (imperv~ buffer radius i~ http~
       9 pm                 0.2.0           daily PM2.5         <NA>             http~
      10 narr               0.3.0           daily weather data~ optional --all ~ http~
      11 drivetime          1.1.0           distance and drive~ care_site [defa~ http~
      # ... with 2 more variables: badge_release_code <glue>, badge_build_code <glue>

