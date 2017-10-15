module Countries exposing (..)

import Http
import Json.Decode exposing (list, string)

import Msg exposing (..)


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


