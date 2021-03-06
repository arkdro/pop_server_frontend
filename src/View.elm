module View exposing (..)

import Html exposing (Html, text, div, img, input, br, button, li)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

import Model exposing (..)
import Msg exposing (..)
import Sig exposing (..)


type alias Validation_hint = (String, String)


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
             [text "Submit"],
         text " ",
         button [type_ "submit",
                     disabled <| is_not_empty model.country,
                     onClick Submit_list_of_countries, input_style]
             [text "List of countries"]
        ]

page_end_items : Model -> List (Html Msg)
page_end_items _ =
    [
     br [] []
    ]


input_style : Html.Attribute a
input_style =
    style
    [
     ("font-size", "1em")
    ]


is_empty : String -> Bool
is_empty str =
    str
        |> String.trim
        |> String.isEmpty


is_not_empty : String -> Bool
is_not_empty str = not (is_empty str)


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


show_requested_data : Model -> List (Html Msg)
show_requested_data model =
    case model.cmd of
        None ->
            show_only_validation model
        List_of_countries ->
            case model.countries of
                Nothing ->
                    show_only_validation model
                Just countries ->
                    show_countries_list countries
        Data_of_country ->
            case model.country_data of
                Nothing ->
                    show_only_validation model
                Just data ->
                    show_country_data data


show_only_validation model =
    [
     view_validation model,
     br [] [],
     div [ style [("color", "lightgrey")] ] [ text "data" ]
    ]

show_countries_list : List String -> List (Html Msg)
show_countries_list countries =
    List.map one_country_div countries


one_country_div : String -> Html Msg
one_country_div country =
    li [ style [("color", "green")] ] [ text country ]


show_country_data data =
    List.map one_country_data_div data


one_country_data_div {year, value} =
    let
        data = toString(year) ++ ", " ++ toString(value)
    in
        div [ style [("color", "blue")] ] [ text data ]





