module Main exposing (..)

import Html exposing (Html, text, div, img, input, br)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


---- MODEL ----


type alias Model =
    {
        country: String,
        start_year: Int,
        stop_year: Int
    }


init : ( Model, Cmd Msg )
init =
    ( {country = "", start_year = 0, stop_year = 0}, Cmd.none )


---- UPDATE ----


type Msg
    =
      NoOp
    | Country String
    | Start_year String
    | Stop_year String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            (model, Cmd.none)
        Country country ->
            ({model | country = country}, Cmd.none)
        Start_year str ->
            let year = calc_year str
            in ({model | start_year = year}, Cmd.none)
        Stop_year str ->
            let year = calc_year str
            in ({model | stop_year = year}, Cmd.none)


---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [
         img [ src "/logo.svg" ] [],
         div [] [ text "Your Elm App is working!" ],
         input [type_ "text", placeholder "Country", onInput Country, input_style] [],
         br [] [],
         input [type_ "text", placeholder "Start year", onInput Start_year, input_style] [],
         br [] [],
         input [type_ "text", placeholder "Stop year", onInput Stop_year, input_style] [],
         view_validation model
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        {
            view = view,
            init = init,
            update = update,
            subscriptions = always Sub.none
        }


---- AUXILLARY ----


input_style : Html.Attribute a
input_style =
    style
    [
     ("font-size", "1em")
    ]


check_existence : Bool
check_existence =
    True


calc_year : String -> Int
calc_year year_str =
    case String.toInt year_str of
        Ok n ->
            n
        Err _ ->
            0


view_validation {start_year, stop_year} =
    let (color, message) = get_color_and_message start_year stop_year
    in div [ style [("color", color)] ] [ text message ]


get_color_and_message start_year stop_year =
    case start_year <= stop_year of
        True ->
            ("green", "OK")
        False ->
            ("red", "Error: start is after stop")
