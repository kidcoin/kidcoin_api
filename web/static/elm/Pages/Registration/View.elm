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


formLabel : Field -> String -> Html
formLabel field inputName =
  let
    labelText =
      if field.hasError then
        fieldLabel field.fieldType ++ " " ++ field.error
      else
        fieldLabel field.fieldType
  in
    label
      [ for inputName
      , classList [ ( "error", field.hasError ) ]
      ]
      [ text <| labelText ]


formField : Signal.Address Action -> Field -> Html
formField address field =
  let
    inputName =
      fieldName field.fieldType

    rowLabel =
      formLabel field inputName

    rowInputType =
      inputType field.fieldType

    classes =
      classList
        [ ( "column", True )
        , ( "form-row", True )
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

    children =
      [ rowLabel
      , rowInput
      ]
  in
    div [ classes ] children


formSubmitButton : Signal.Address Action -> Html
formSubmitButton address =
  div
    [ class "column" ]
    [ input
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
    ]


householdFormField : Signal.Address Action -> Model -> Html
householdFormField address model =
  formField address model.household


usernameFormField : Signal.Address Action -> Model -> Html
usernameFormField address model =
  formField address model.username


passwordFormField : Signal.Address Action -> Model -> Html
passwordFormField address model =
  formField address model.password


passwordConfirmationFormField : Signal.Address Action -> Model -> Html
passwordConfirmationFormField address model =
  formField address model.passwordConfirmation


formView : Signal.Address Action -> Model -> Html
formView address model =
  div
    []
    [ formRow
        [ householdFormField address model
        , usernameFormField address model
        ]
    , formRow
        [ passwordFormField address model
        , passwordConfirmationFormField address model
        ]
    , formRow
        [ formSubmitButton address
        ]
    ]


formRow : List Html -> Html
formRow children =
  div [ class "row" ] children


inputType : FieldType -> String
inputType fieldType =
  case fieldType of
    PasswordField ->
      "password"

    PasswordConfirmationField ->
      "password"

    otherwise ->
      "text"


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "form" ]
    [ h4 [] [ text "Register Household" ]
    , formView address model
    , text <| toString model.isUsernameAvailable
    ]
