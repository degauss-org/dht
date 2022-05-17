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
      suppressMessages(get_degauss_core_lib_env())
    Output
      # A tibble: 11 x 4
         degauss_name       degauss_version degauss_description       degauss_argument
         <chr>              <chr>           <chr>                     <chr>           
       1 geocoder           3.2.0           geocodes                  valid_geocode_s~
       2 census_block_group 0.5.1           census block group and t~ census year [de~
       3 dep_index          0.2.0           census tract-level depri~ <NA>            
       4 greenspace         0.3.0           enhanced vegetation index <NA>            
       5 roads              0.2.1           proximity and length of ~ buffer radius i~
       6 aadt               0.2.0           average annual daily tra~ buffer radius i~
       7 nlcd               0.2.0           land cover (imperviousne~ buffer radius i~
       8 drivetime          1.1.0           distance and drive time ~ care_site [defa~
       9 st_census_tract    0.2.0           census tract identifiers~ <NA>            
      10 pm                 0.2.0           daily PM2.5               <NA>            
      11 narr               0.3.0           daily weather data (temp~ optional --all ~

---

    Code
      suppressMessages(get_degauss_core_lib_env(geocoder = FALSE))
    Output
      # A tibble: 10 x 4
         degauss_name       degauss_version degauss_description       degauss_argument
         <chr>              <chr>           <chr>                     <chr>           
       1 census_block_group 0.5.1           census block group and t~ census year [de~
       2 dep_index          0.2.0           census tract-level depri~ <NA>            
       3 greenspace         0.3.0           enhanced vegetation index <NA>            
       4 roads              0.2.1           proximity and length of ~ buffer radius i~
       5 aadt               0.2.0           average annual daily tra~ buffer radius i~
       6 nlcd               0.2.0           land cover (imperviousne~ buffer radius i~
       7 drivetime          1.1.0           distance and drive time ~ care_site [defa~
       8 st_census_tract    0.2.0           census tract identifiers~ <NA>            
       9 pm                 0.2.0           daily PM2.5               <NA>            
      10 narr               0.3.0           daily weather data (temp~ optional --all ~

