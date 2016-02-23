module Pages.Login.View (..) where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Json.Decode
import Pages.Login.Model exposing (..)


fieldLabel : FieldType -> String
fieldLabel fieldType =
  case fieldType of
    PasswordField ->
      "Password"

    UsernameField ->
      "Username"


fieldName : FieldType -> String
fieldName fieldType =
  case fieldType of
    PasswordField ->
      "password"

    UsernameField ->
      "username"


inputType : FieldType -> String
inputType fieldType =
  case fieldType of
    PasswordField ->
      "password"

    otherwise ->
      "text"


formField : Signal.Address Action -> Field -> Html
formField address field =
  let
    inputName =
      fieldName field.fieldType

    labelText =
      fieldLabel field.fieldType

    rowLabel =
      if field.hasError then
        label
          [ for inputName, class "error" ]
          [ text <| labelText ++ " " ++ field.error ]
      else
        label [ for inputName ] [ text labelText ]

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
    div
      [ classes ]
      children


formSubmitButton : Signal.Address Action -> Html
formSubmitButton address =
  div
    [ class "column" ]
    [ input
        [ type' "button"
        , name "login"
        , value "Login"
        , onWithOptions
            "click"
            { stopPropagation = True, preventDefault = True }
            Json.Decode.value
            (\_ -> Signal.message address FormSubmit)
        ]
        []
    ]


formView : Signal.Address Action -> Model -> Html
formView address model =
  div
    []
    [ formRow
        [ formField address model.username
        ]
    , formRow
        [ formField address model.password
        ]
    , formRow
        [ formSubmitButton address
        ]
    ]


formRow : List Html -> Html
formRow children =
  div [ class "row" ] children


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "form" ]
    [ h4 [] [ text "Login" ]
    , formView address model
    ]
