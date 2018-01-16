module Main exposing (..)

import Decoders
import Html
import Html.Attributes
import Html.Events
import Kinto
import Types exposing (Item, Model, Msg(..), User)


---- MODEL ----


init : ( Model, Cmd Msg )
init =
    ( { user = Nothing, username = "", password = "" }, Cmd.none )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UsernameUpdate username ->
            ( { model | username = username }, Cmd.none )

        PasswordUpdate password ->
            ( { model | password = password }, Cmd.none )

        Login ->
            let
                user =
                    { username = model.username
                    , client =
                        Kinto.client
                            "https://kinto.agopian.info/v1/"
                            (Kinto.Basic model.username model.password)
                    , items = []
                    }
            in
                ( { model | user = Just user }, getItemList user )

        ItemListUpdate (Ok itemPager) ->
            let
                updatedUser =
                    model.user
                        |> Maybe.map (\user -> { user | items = itemPager.objects })
            in
                ( { model | user = updatedUser }, Cmd.none )

        ItemListUpdate (Err err) ->
            let
                _ =
                    Debug.log "Error while getting the list of items" err
            in
                ( model, Cmd.none )


getItemList : User -> Cmd Msg
getItemList user =
    user.client
        |> Kinto.getList (Decoders.recordResource user.username)
        |> Kinto.send ItemListUpdate



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
