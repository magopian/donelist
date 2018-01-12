module Main exposing (..)

import Date
import Html
import Html.Attributes


---- MODEL ----


type alias Item =
    { when : Date.Date
    , url : String
    , comment : Maybe String
    }


type alias User =
    { token : String
    , items : List Item
    }


type alias Model =
    Maybe User


init : ( Model, Cmd Msg )
init =
    ( Nothing, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.h1 [] [ Html.text "The DONE List" ]
        , viewAskUser
        ]


viewAskUser : Html.Html Msg
viewAskUser =
    Html.form []
        [ Html.input [ Html.Attributes.placeholder "username" ] []
        , Html.input [ Html.Attributes.placeholder "password" ] []
        , Html.input [ Html.Attributes.type_ "submit", Html.Attributes.value "Display my DONE List" ] []
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
