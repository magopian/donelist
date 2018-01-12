module Main exposing (..)

import Date
import Html
import Html.Attributes
import Html.Events


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
    { user : Maybe User
    , username : String
    , password : String
    }


init : ( Model, Cmd Msg )
init =
    ( { user = Nothing, username = "", password = "" }, Cmd.none )



---- UPDATE ----


type Msg
    = UsernameUpdate String
    | PasswordUpdate String
    | Login


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UsernameUpdate username ->
            ( { model | username = username }, Cmd.none )

        PasswordUpdate password ->
            ( { model | password = password }, Cmd.none )

        Login ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html.Html Msg
view model =
    Html.div []
        [ Html.h1 [] [ Html.text "The DONE List" ]
        , viewAskUser model.username model.password
        ]


viewAskUser : String -> String -> Html.Html Msg
viewAskUser username password =
    Html.form
        [ Html.Events.onSubmit Login
        ]
        [ Html.input
            [ Html.Attributes.placeholder "username"
            , Html.Attributes.value username
            , Html.Events.onInput UsernameUpdate
            ]
            []
        , Html.input
            [ Html.Attributes.placeholder "password"
            , Html.Attributes.type_ "password"
            , Html.Attributes.value password
            , Html.Events.onInput PasswordUpdate
            ]
            []
        , Html.input
            [ Html.Attributes.type_ "submit"
            , Html.Attributes.value "Display my DONE List"
            ]
            []
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
