module Pages.Registration.View (..) where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Json.Decode
import Pages.Registration.Model exposing (..)


fieldLabel : FieldType -> String
fieldLabel fieldType =
  case fieldType of
    HouseholdField ->
      "Household"

    PasswordConfirmationField ->
      "Confirm Password"

    PasswordField ->
      "Password"

    UsernameField ->
      "Username"


fieldName : FieldType -> String
fieldName fieldType =
  case fieldType of
    HouseholdField ->
      "household"

    PasswordConfirmationField ->
      "password_confirmation"

    PasswordField ->
      "password"

    UsernameField ->
      "username"


inputType : FieldType -> String
inputType fieldType =
  case fieldType of
    PasswordField ->
      "password"

    PasswordConfirmationField ->
      "password"

    otherwise ->
      "text"


formRow : Signal.Address Action -> Field -> Html
formRow address field =
  let
    inputName =
      fieldName field.fieldType

    labelText =
      fieldLabel field.fieldType

    rowLabel =
      label [ for inputName ] [ text labelText ]

    rowInputType =
      inputType field.fieldType

    classes =
      classList
        [ ( "form-row", True )
        , ( "error", field.hasError )
        ]

    rowInputAttributes =
      [ type' rowInputType
      , name inputName
      , value field.value
      , on
          "change"
          Html.Events.targetValue
          (Signal.message address << UpdateField field.fieldType)
      ]

    rowInput =
      input rowInputAttributes []

    errorMessage =
      if field.hasError then
        span [ class "error" ] [ text field.error ]
      else
        span [] []

    children =
      [ rowLabel
      , rowInput
      , errorMessage
      ]
  in
    div
      [ classes ]
      children


formSubmitButton : Signal.Address Action -> Html
formSubmitButton address =
  input
    [ type' "button"
    , name "register"
    , value "Register"
    , onWithOptions
        "click"
        { stopPropagation = True, preventDefault = True }
        Json.Decode.value
        (\_ -> Signal.message address FormSubmit)
    ]
    []


formView : Signal.Address Action -> Model -> Html
formView address model =
  div
    []
    [ formRow address model.household
    , formRow address model.username
    , formRow address model.password
    , formRow address model.passwordConfirmation
    , formSubmitButton address
    ]


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "form" ]
    [ formView address model ]
