module Msg exposing (..)

import Http


type Msg
    =
      NoOp
    | Submit
    | Country String
    | Start_year String
    | Stop_year String
    | Countries (Result Http.Error (List String))


