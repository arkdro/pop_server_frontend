module Main exposing (..)

import Html exposing (Html, text, div, img, input, br, button, li)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Http
import Json.Decode exposing (list, string)

import Model exposing (Model)
import Msg exposing (..)


---- MODEL ----


type alias Validation_hint = (String, String)


init : ( Model, Cmd Msg )
init =
    let
        model = (Model.empty_model)
    in
        (model, Cmd.none)


---- UPDATE ----


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
        Submit ->
            (model, get_countries)
        Countries (Ok countries) ->
            let
                new_model = {model | countries = Just countries}
            in
                (new_model , Cmd.none)
        Countries (Err err) ->
            let _ = Debug.log "update, countries, error" err in
            (model, Cmd.none)


---- VIEW ----


view : Model -> Html Msg
view model =
    let
        page_items =
            (page_start_items model)
            ++ show_requested_data model
            ++ (page_end_items model)
    in
        div [] page_items


page_start_items : Model -> List (Html Msg)
page_start_items model =
        [
         img [ src "/logo.svg" ] [],
         div [] [ text "Your Elm App is working!" ],
         input [type_ "text", placeholder "Country", onInput Country, input_style] [],
         br [] [],
         input [type_ "text", placeholder "Start year", onInput Start_year, input_style] [],
         br [] [],
         input [type_ "text", placeholder "Stop year", onInput Stop_year, input_style] [],
         br [] [],
         button [type_ "submit",
                     disabled <| is_empty model.country,
                     onClick Submit, input_style]
             [text "Submit"]
        ]

page_end_items : Model -> List (Html Msg)
page_end_items _ =
    [
     br [] []
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


view_validation : Model -> Html msg
view_validation {start_year, stop_year} =
    let (color, message) = get_color_and_message start_year stop_year
    in div [ style [("color", color)] ] [ text message ]


get_color_and_message : Int -> Int -> Validation_hint
get_color_and_message start_year stop_year =
    case start_year <= stop_year of
        True ->
            ("green", "OK")
        False ->
            ("red", "Error: start is after stop")


is_empty : String -> Bool
is_empty str =
    str
        |> String.trim
        |> String.isEmpty


get_countries : Cmd Msg
get_countries =
    let
        url = get_countries_url
        request = Http.get url countries_decoder
    in
        Http.send Countries request


countries_decoder : Json.Decode.Decoder (List String)
countries_decoder =
    Json.Decode.list country_list_item_decoder


country_list_item_decoder : Json.Decode.Decoder String
country_list_item_decoder =
    Json.Decode.field "Name" Json.Decode.string


get_countries_url : String
get_countries_url =
    base_url ++ "/country"


base_url : String
base_url =
    "http://localhost:8081"


show_requested_data : Model -> List (Html Msg)
show_requested_data model =
    case model.countries of
        Nothing ->
            [
             view_validation model,
             br [] [],
             div [ style [("color", "lightgrey")] ] [ text "data" ]
            ]
        Just countries ->
            show_countries_list countries


show_countries_list : List String -> List (Html Msg)
show_countries_list countries =
    List.map one_country_div countries


one_country_div : String -> Html Msg
one_country_div country =
    li [ style [("color", "green")] ] [ text country ]


