module Types exposing (..)

import Kinto


type alias Item =
    { id : String
    , last_modified : Int
    , url : Maybe String
    , comment : Maybe String
    }


type alias User =
    { username : Username
    , client : Kinto.Client
    , items : List Item
    }


type alias Username =
    String


type alias Password =
    String


type alias Model =
    { user : Maybe User
    , username : Username
    , password : Password
    }


type Msg
    = UsernameUpdate String
    | PasswordUpdate String
    | Login
    | ItemListUpdate (Result Kinto.Error (Kinto.Pager Item))
