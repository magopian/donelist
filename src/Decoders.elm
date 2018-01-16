module Decoders exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode
import Kinto
import Types exposing (Item, Username)


-- Not useful for the code, but serves as documentation on how to setup the Kinto collection.


json_schema : String
json_schema =
    """
        {
          "type": "object",
          "properties": {
            "url": {
              "type": "string",
              "title": "URL",
              "description": "Link to the thing that is done (Github url, comment, Bugzilla bug...)"
            },
            "comment": {
              "type": "string",
              "title": "Comment",
              "description": "Details about the thing that was done"
            }
          }
        }
    """


ui_schema : String
ui_schema =
    """
        {
          "ui:order": [
            "url",
            "comment"
          ],
          "comment": {
            "ui:widget": "textarea"
          }
        }
    """



-- Decoders and Encoders for Kinto


decodeItem : Decode.Decoder Item
decodeItem =
    Decode.map4 Item
        (Decode.field "id" Decode.string)
        (Decode.field "last_modified" Decode.int)
        (Decode.maybe (Decode.field "url" Decode.string))
        (Decode.maybe (Decode.field "comment" Decode.string))


encodeItem : Maybe String -> Maybe String -> Encode.Value
encodeItem url comment =
    Encode.object
        [ ( "url", Encode.string (Maybe.withDefault "" url) )
        , ( "comment", Encode.string (Maybe.withDefault "" comment) )
        ]



-- Kinto resources


recordResource : Username -> Kinto.Resource Item
recordResource username =
    Kinto.recordResource "donelist" username decodeItem
