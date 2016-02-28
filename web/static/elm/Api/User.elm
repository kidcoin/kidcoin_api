module Api.User (..) where

import Effects exposing (Effects, none)
import Http
import Json.Decode
import Json.Encode
import Task


isUsernameAvailable : String -> a -> a -> Effects a
isUsernameAvailable username availableAction unavailableAction =
  let
    url =
      "/api/username/" ++ username

    decoder =
      usernameAvailabilityDecoder availableAction unavailableAction

    request =
      Http.get decoder url

    httpRequest =
      Task.onError
        request
        (\error -> Task.succeed availableAction)
  in
    Effects.task httpRequest


usernameAvailabilityDecoder : a -> a -> Json.Decode.Decoder a
usernameAvailabilityDecoder availableAction unavailableAction =
  Json.Decode.object1
    (\bool ->
      case bool of
        True ->
          availableAction

        False ->
          unavailableAction
    )
    (Json.Decode.at
      [ "data", "available" ]
      Json.Decode.bool
    )
