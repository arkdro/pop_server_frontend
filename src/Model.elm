module Model exposing (Model, Country_item, empty_model)

import Sig exposing (..)


type alias Model =
    {
        cmd: Sig,
        country: String,
        start_year: Int,
        stop_year: Int,
        countries: Maybe (List String),
        country_data: Maybe (List Country_item)
    }


type alias Country_item =
    {
        year: Int,
        value: Float
    }


empty_model : Model
empty_model =
    {
     cmd = None,
     country = "",
     start_year = 0,
     stop_year = 0,
     countries = Nothing,
     country_data = Nothing
    }


