module Country exposing (..)

import Http
import Json.Decode exposing (list, string)

import Model exposing (Model, Country_item)
import Msg exposing (..)


get_country_data : Model.Model -> Cmd Msg
get_country_data ({country, start_year, stop_year} as model) =
    let
        url = get_country_url ++ country
        request = Http.get url country_data_decoder
    in
        Http.send Msg.Country_data request


country_data_decoder : Json.Decode.Decoder (List Model.Country_item)
country_data_decoder =
    Json.Decode.list country_list_item_decoder


country_list_item_decoder : Json.Decode.Decoder Model.Country_item
country_list_item_decoder =
    Json.Decode.map2 Model.Country_item
        (Json.Decode.field "Year" Json.Decode.int)
        (Json.Decode.field "Value" Json.Decode.float)


get_country_url : String
get_country_url =
    base_url ++ "/country/"


base_url : String
base_url =
    "http://localhost:8081"


