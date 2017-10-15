module Main exposing (..)

import Html exposing (Html)

import Model exposing (Model)
import Msg exposing (..)
import Sig exposing (..)
import Countries exposing (get_countries)
import Country exposing (get_country_data)
import View exposing (..)


---- INIT ----


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
        Submit_list_of_countries ->
            (model, Countries.get_countries)
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


calc_year : String -> Int
calc_year year_str =
    case String.toInt year_str of
        Ok n ->
            n
        Err _ ->
            0


