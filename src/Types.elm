module Types exposing (..)

import Kinto


type alias Item =
    { id : String
    , last_modified : Int
    , url : Maybe String
    , comment : Maybe String
    }


type alias DoneList =
    Kinto.Pager Item


type DoneListStatus
    = NotRetrieved
    | Retrieving
    | Retrieved DoneList
    | ErrorWhileRetrieving Kinto.Error


type alias User =
    { username : Username
    , client : Kinto.Client
    }


type alias Username =
    String


type alias Password =
    String


type alias Model =
    { user : Maybe User
    , doneList : DoneListStatus
    , username : Username
    , password : Password
    }


type Msg
    = UsernameUpdate String
    | PasswordUpdate String
    | Login
    | ItemListUpdate (Result Kinto.Error (Kinto.Pager Item))
