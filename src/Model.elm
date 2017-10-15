module Model exposing (Model, empty_model)


type alias Model =
    {
        country: String,
        start_year: Int,
        stop_year: Int,
        countries: Maybe (List String)
    }

empty_model : Model
empty_model =
    {
     country = "",
     start_year = 0,
     stop_year = 0,
     countries = Nothing,
     country_data = Nothing
    }


