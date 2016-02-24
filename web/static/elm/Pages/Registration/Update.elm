module Pages.Registration.Update (..) where

import Effects exposing (Effects, none)
import Http
import Json.Decode
import Pages.Registration.Model exposing (..)
import String exposing (isEmpty, trim)
import Task


checkUsernameAvailability : Model -> ( Model, Effects Action )
checkUsernameAvailability model =
  let
    url =
      "/api/username/" ++ model.username.value

    request =
      Http.get (Json.Decode.succeed UsernameNotAvailable) url

    httpRequest =
      Task.onError request (\error -> Task.succeed UsernameAvailable)
  in
    ( model, Effects.task httpRequest )


noEffects : Model -> ( Model, Effects Action )
noEffects model =
  ( model, Effects.none )


passwordMatches : Model -> Field
passwordMatches model =
  if model.password.value == model.passwordConfirmation.value then
    model.password
  else
    let
      password =
        model.password
    in
      { password
        | error = "Passwords do not match"
        , hasError = True
      }


redirectToLoginPageOrShowErrors : Model -> ( Model, Effects Action )
redirectToLoginPageOrShowErrors model =
  let
    model' =
      Debug.log "model after validation" <| validateFields model

    hasError =
      model'.household.hasError
        || model'.username.hasError
        || model'.passwordConfirmation.hasError
        || model'.password.hasError
  in
    case hasError of
      True ->
        model'
          |> noEffects

      False ->
        -- redirect to login page
        model'
          |> noEffects


setFieldValue : Field -> String -> Field
setFieldValue field value =
  { field
    | value = value
  }


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case (Debug.log "processing registration update action" action) of
    FormSubmit ->
      redirectToLoginPageOrShowErrors model

    UpdateField HouseholdField value ->
      setFieldValue model.household (trim value)
        |> updateHouseholdInModel model
        |> noEffects

    UpdateField PasswordConfirmationField value ->
      setFieldValue model.passwordConfirmation (trim value)
        |> updatePasswordConfirmationInModel model
        |> noEffects

    UpdateField PasswordField value ->
      setFieldValue model.password value
        |> updatePasswordInModel model
        |> noEffects

    UpdateField UsernameField value ->
      setFieldValue model.username value
        |> updateUsernameInModel model
        |> checkUsernameAvailability

    UsernameAvailable ->
      { model
        | usernameAvailable = True
      }
        |> noEffects

    UsernameNotAvailable ->
      { model
        | usernameAvailable = False
      }
        |> noEffects


updateHouseholdInModel : Model -> Field -> Model
updateHouseholdInModel model field =
  { model
    | household = field
  }


updatePasswordInModel : Model -> Field -> Model
updatePasswordInModel model field =
  { model
    | password = field
  }


updatePasswordConfirmationInModel : Model -> Field -> Model
updatePasswordConfirmationInModel model field =
  { model
    | passwordConfirmation = field
  }


updateUsernameInModel : Model -> Field -> Model
updateUsernameInModel model field =
  { model
    | username = field
  }


validateField : Field -> Field
validateField field =
  if field.value |> isEmpty then
    { field
      | error = " cannot be empty"
      , hasError = True
    }
  else
    { field
      | error = ""
      , hasError = False
    }


validateFields : Model -> Model
validateFields model =
  let
    household =
      validateField model.household

    username =
      validateField model.username

    password =
      validateField model.password

    passwordConfirmation =
      validateField model.passwordConfirmation
  in
    { model
      | household = household
      , username = username
      , password = password
      , passwordConfirmation = passwordConfirmation
    }
