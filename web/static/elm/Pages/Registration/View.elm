module Pages.Registration.View where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

import Pages.Registration.Model exposing (..)

view : Signal.Address Action -> Model -> Html
view address model =
    text <| "This is registration from embedded module"
