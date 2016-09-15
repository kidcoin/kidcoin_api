module Api.User (..) where

import Effects exposing (Effects, none)
import Http
import Json.Decode exposing ((:=))
import Json.Encode exposing (string)
import String
import Task


type alias User =
  { household : String
  , username : String
  , email : String
  }


createUser : User -> String -> (String -> a) -> (String -> a) -> Effects a
createUser user password succeedAction failedAction =
  let
    decoder =
      createUserDecoder succeedAction

    body =
      Http.string <| toJson user password

    request =
      Http.post
        decoder
        "/api/user.json"
        body

    httpRequest =
      Task.onError
        request
        (\error -> Task.succeed failedAction error)
  in
    Effects.task httpRequest

createUserDecoder : (String -> a) -> Json.Decode.Decoder a
createUserDecoder succeedAction =
  Json.Decode.object1
    action
    (Json.Decode.object1
      (\data ->
        Json.Decode.object3
          User
          ("household" := Json.Decode.string)
          ("username" := Json.Decode.string)
          ("email" := Json.Decode.string)
          )
          ("data" := Json.
    )


isUsernameAvailable : String -> (Bool -> a) -> Effects a
isUsernameAvailable username action =
  let
    url =
      "/api/username/" ++ username ++ ".json"

    decoder =
      usernameAvailabilityDecoder action

    request =
      Http.get decoder url

    httpRequest =
      Task.onError
        request
        (\error -> Task.succeed (action True))
  in
    Effects.task httpRequest


toJson : User -> String -> Json.Encode.Value
toJson user password =
  Json.Encode.object
    [ ( "username", string user.username )
    , ( "email", string user.email )
    , ( "household", string user.household )
    , ( "password", string password )
    ]


usernameAvailabilityDecoder : (Bool -> a) -> Json.Decode.Decoder a
usernameAvailabilityDecoder action =
  Json.Decode.object1
    action
    (Json.Decode.at
      [ "data", "available" ]
      Json.Decode.bool
    )
