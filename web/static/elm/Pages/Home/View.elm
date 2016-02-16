module Pages.Home.View where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

import Pages.Home.Model exposing (..)

view : Signal.Address Action -> Model -> Html
view address model =
    text <| "This is home from embedded module"
