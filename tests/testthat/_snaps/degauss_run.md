# can use degauss_run

    Code
      d_out
    Output
      # A tibble: 198 x 11
         id    address clean~1 parse~2 parse~3 parse~4 parse~5 parse~6 parse~7 parse~8
         <chr> <chr>   <chr>   <chr>     <dbl> <chr>   <chr>   <chr>     <dbl> <chr>  
       1 5500~ 2854 R~ 2854 R~ 2854 r~    2854 rosean~ green ~ oh        45239 <NA>   
       2 9800~ 407 SO~ 407 SO~ 407 so~     407 southv~ cincin~ oh        45219 <NA>   
       3 5910~ 909 GR~ 909 GR~ 909 gr~     909 gretna~ forest~ oh        45240 <NA>   
       4 5500~ P.O. B~ P O BO~ green ~      NA <NA>    green ~ oh        45238 p o bo~
       5 4100~ PO 123~ PO 123~ cincin~      NA <NA>    cincin~ oh        45208 <NA>   
       6 9000~ 3333 B~ 3333 B~ 3333 b~    3333 burnet~ cincin~ oh        45229 <NA>   
       7 2160~ 222 E ~ 222 E ~ 222 e ~     222 e cent~ cincin~ oh        45202 <NA>   
       8 6710~ foreign foreign foreign      NA <NA>    <NA>    <NA>         NA <NA>   
       9 6710~ <NA>    <NA>    <NA>         NA <NA>    <NA>    <NA>         NA <NA>   
      10 6710~ <NA>    <NA>    <NA>         NA <NA>    <NA>    <NA>         NA <NA>   
      # ... with 188 more rows, 1 more variable: parsed.house <chr>, and abbreviated
      #   variable names 1: cleaned_address, 2: parsed_address,
      #   3: parsed.house_number, 4: parsed.road, 5: parsed.city, 6: parsed.state,
      #   7: parsed.postcode, 8: parsed.po_box

# can use degauss_run without specifying version

    Code
      d_out
    Output
      # A tibble: 198 x 11
         id    address clean~1 parse~2 parse~3 parse~4 parse~5 parse~6 parse~7 parse~8
         <chr> <chr>   <chr>   <chr>     <dbl> <chr>   <chr>   <chr>     <dbl> <chr>  
       1 5500~ 2854 R~ 2854 R~ 2854 r~    2854 rosean~ green ~ oh        45239 <NA>   
       2 9800~ 407 SO~ 407 SO~ 407 so~     407 southv~ cincin~ oh        45219 <NA>   
       3 5910~ 909 GR~ 909 GR~ 909 gr~     909 gretna~ forest~ oh        45240 <NA>   
       4 5500~ P.O. B~ P O BO~ green ~      NA <NA>    green ~ oh        45238 p o bo~
       5 4100~ PO 123~ PO 123~ cincin~      NA <NA>    cincin~ oh        45208 <NA>   
       6 9000~ 3333 B~ 3333 B~ 3333 b~    3333 burnet~ cincin~ oh        45229 <NA>   
       7 2160~ 222 E ~ 222 E ~ 222 e ~     222 e cent~ cincin~ oh        45202 <NA>   
       8 6710~ foreign foreign <NA>         NA <NA>    <NA>    <NA>         NA <NA>   
       9 6710~ <NA>    <NA>    <NA>         NA <NA>    <NA>    <NA>         NA <NA>   
      10 6710~ <NA>    <NA>    <NA>         NA <NA>    <NA>    <NA>         NA <NA>   
      # ... with 188 more rows, 1 more variable: parsed.house <chr>, and abbreviated
      #   variable names 1: cleaned_address, 2: parsed_address,
      #   3: parsed.house_number, 4: parsed.road, 5: parsed.city, 6: parsed.state,
      #   7: parsed.postcode, 8: parsed.po_box

