module Pages.Registration.View (..) where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Pages.Registration.Model exposing (..)


formRow : String -> String -> Html
formRow field displayName =
  div
    [ class "form-row" ]
    [ label [ for field ] [ text displayName ]
    , input [ type' "text", name field, value "" ] []
    ]


formView : Signal.Address Action -> Model -> Html
formView address model =
  Html.form
    []
    [ formRow "household" "Household Name"
    , formRow "username" "Username"
    , formRow "password" "Password"
    , formRow "password_confirmation" "Password Confirmation"
    , input [ type' "submit", name "register", value "Register" ] []
    ]


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "form" ]
    [ formView address model ]
