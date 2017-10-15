module Msg exposing (..)

import Http

import Model exposing (Country_item)


type Msg
    =
      NoOp
    | Submit
    | Submit_list_of_countries
    | Country String
    | Start_year String
    | Stop_year String
    | Countries (Result Http.Error (List String))
    | Country_data (Result Http.Error (List Model.Country_item))


