module Types exposing (..)

import Kinto


type alias Item =
    { id : String
    , last_modified : Int
    , url : Maybe String
    , comment : Maybe String
    }


type DoneList
    = NotRetrieved
    | Retrieving
    | Retrieved (Kinto.Pager Item)
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
    , doneList : DoneList
    , username : Username
    , password : Password
    }


type Msg
    = UsernameUpdate String
    | PasswordUpdate String
    | Login
    | ItemListUpdate (Result Kinto.Error (Kinto.Pager Item))
