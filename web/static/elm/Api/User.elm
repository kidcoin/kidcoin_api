module Api.User (..) where

import Effects exposing (Effects, none)
import Http
import Json.Decode
import Json.Encode
import Task


type alias User =
  { household : String
  , username : String
  , email : String
  }


createUser : User -> String -> (String -> a) -> (String -> a) -> Effects a
createUser user password succeedAction failedAction =
  Effects.none


isUsernameAvailable : String -> (Bool -> a) -> Effects a
isUsernameAvailable username action =
  let
    url =
      "/api/username/" ++ username

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


usernameAvailabilityDecoder : (Bool -> a) -> Json.Decode.Decoder a
usernameAvailabilityDecoder action =
  Json.Decode.object1
    action
    (Json.Decode.at
      [ "data", "available" ]
      Json.Decode.bool
    )
