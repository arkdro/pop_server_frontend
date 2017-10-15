module Main exposing (..)

import Html exposing (Html)
import Http
import Json.Decode exposing (list, string)

import Model exposing (Model)
import Msg exposing (..)
import Sig exposing (..)
import Country exposing (get_country_data)
import View exposing (..)


---- MODEL ----


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
            (model, Country.get_country_data model)
        Country_data (Ok data) ->
            let
                new_model = {model | country_data = Just data,
                                 cmd = Data_of_country}
            in
                (new_model , Cmd.none)
        Country_data (Err err) ->
            let _ = Debug.log "update, country data, error" err in
            (model, Cmd.none)
        Countries (Ok countries) ->
            let
                new_model = {model | countries = Just countries,
                                 cmd = List_of_countries}
            in
                (new_model , Cmd.none)
        Countries (Err err) ->
            let _ = Debug.log "update, countries, error" err in
            (model, Cmd.none)


---- VIEW ----



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        {
            view = View.view,
            init = init,
            update = update,
            subscriptions = always Sub.none
        }


---- AUXILLARY ----


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


