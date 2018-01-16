module Main exposing (..)

import Decoders
import Html
import Html.Attributes
import Html.Events
import Kinto
import Types exposing (DoneList, DoneListStatus(..), Item, Model, Msg(..), Password, User, Username)


kintoServer : String
kintoServer =
    "https://kinto.agopian.info/v1/"


editLink : String -> String -> String
editLink collection id =
    kintoServer ++ "admin/#/buckets/donelist/collections/" ++ collection ++ "/records/" ++ id



---- MODEL ----


init : ( Model, Cmd Msg )
init =
    ( { user = Nothing, doneList = NotRetrieved, username = "", password = "" }, Cmd.none )



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
                            kintoServer
                            (Kinto.Basic model.username model.password)
                    }
            in
                ( { model | user = Just user, doneList = Retrieving }
                , getItemList user
                )

        ItemListUpdate (Ok itemPager) ->
            ( { model | doneList = Retrieved itemPager }, Cmd.none )

        ItemListUpdate (Err err) ->
            let
                _ =
                    Debug.log "Error while getting the list of items" err
            in
                ( { model | doneList = ErrorWhileRetrieving err }, Cmd.none )


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
        , case model.doneList of
            NotRetrieved ->
                viewAskUser model.username model.password

            Retrieving ->
                Html.text "Please wait while we're retrieving the Done List"

            ErrorWhileRetrieving err ->
                Html.div []
                    [ viewAskUser model.username model.password
                    , Html.br [] []
                    , Html.div [] [ Html.text "Error while retrieving the Done List: " ]
                    , Html.div [] [ Html.text <| toString err ]
                    ]

            Retrieved pager ->
                Html.div []
                    [ Html.text "Here's your Done List: "
                    , viewDoneList model.username pager
                    ]
        ]


viewAskUser : Username -> Password -> Html.Html Msg
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


viewItem : Username -> Item -> Html.Html Msg
viewItem username item =
    let
        comment =
            Maybe.withDefault item.id item.comment
                |> Html.text

        link =
            item.url
                |> Maybe.map (\url -> Html.a [ Html.Attributes.href url ] [ Html.text "[link]" ])
                |> Maybe.withDefault (Html.text "")

        edit =
            Html.a
                [ Html.Attributes.href <| editLink username item.id ]
                [ Html.text "[edit]" ]
    in
        Html.li []
            [ Html.text <| toString item.last_modified
            , Html.text ": "
            , comment
            , link
            , edit
            ]


viewDoneList : Username -> DoneList -> Html.Html Msg
viewDoneList username doneList =
    doneList.objects
        |> List.map (viewItem username)
        |> Html.ul []



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
