module Model exposing (Model)


type alias Model =
    {
        country: String,
        start_year: Int,
        stop_year: Int,
        countries: Maybe (List String)
    }

