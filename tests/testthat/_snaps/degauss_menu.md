# create degauss menu data

    Code
      suppressMessages(create_degauss_menu_data())
    Output
      # A tibble: 11 x 7
         name          version description argument argument_default url   degauss_cmd
         <chr>         <chr>   <chr>       <chr>    <chr>            <glu> <chr>      
       1 geocoder      3.2.0   geocodes    valid_g~ 0.5              http~ docker run~
       2 census_block~ 0.5.1   census blo~ census ~ 2010             http~ docker run~
       3 st_census_tr~ 0.2.0   census tra~ <NA>     <NA>             http~ docker run~
       4 dep_index     0.2.0   census tra~ <NA>     <NA>             http~ docker run~
       5 roads         0.2.1   proximity ~ buffer ~ 400              http~ docker run~
       6 aadt          0.2.0   average an~ buffer ~ 400              http~ docker run~
       7 greenspace    0.3.0   enhanced v~ <NA>     <NA>             http~ docker run~
       8 nlcd          0.2.0   land cover~ buffer ~ 400              http~ docker run~
       9 pm            0.2.0   daily PM2.5 <NA>     <NA>             http~ docker run~
      10 narr          0.3.0   daily weat~ optiona~ no_flag_returns~ http~ docker run~
      11 drivetime     1.1.0   distance a~ care_si~ none             http~ docker run~

