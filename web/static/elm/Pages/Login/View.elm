module Pages.Login.View (..) where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Pages.Login.Model exposing (..)


view : Signal.Address Action -> Model -> Html
view address model =
  text <| "This is login from embedded module"
