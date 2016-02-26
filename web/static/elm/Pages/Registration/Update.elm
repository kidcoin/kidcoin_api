module Pages.Registration.Update (..) where

import Effects exposing (Effects, none)
import Http
import Json.Decode exposing ((:=))
import Pages.Registration.Model exposing (..)
import Regex
import String exposing (isEmpty, trim)
import Task


checkUsernameAvailability : Model -> ( Model, Effects Action )
checkUsernameAvailability model =
  if model.username.hasError then
    ( model, Effects.none )
  else
    let
      url =
        "/api/username/" ++ model.username.value

      request =
        Http.get usernameAvailabilityDecoder url

      httpRequest =
        Task.onError
          request
          (\error -> Task.succeed UsernameAvailable)
    in
      ( model, Effects.task httpRequest )


clearFieldError : Field -> Field
clearFieldError field =
  { field
    | error = ""
    , hasError = False
  }


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
      Debug.log "model after validation" <| validate model

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


setFieldError : Field -> String -> Field
setFieldError field error =
  { field
    | error = error
    , hasError = True
  }


setFieldValue : Field -> String -> Field
setFieldValue field value =
  { field
    | value = value
  }


setHousehold : Model -> Field -> Model
setHousehold model field =
  { model
    | household = field
  }


setPassword : Model -> Field -> Model
setPassword model field =
  { model
    | password = field
  }


setPasswordConfirmation : Model -> Field -> Model
setPasswordConfirmation model field =
  { model
    | passwordConfirmation = field
  }


setUsername : Model -> Field -> Model
setUsername model field =
  { model
    | username = field
  }


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case (Debug.log "processing registration update action" action) of
    FormSubmit ->
      redirectToLoginPageOrShowErrors model

    UpdateField HouseholdField value ->
      setFieldValue model.household (trim value)
        |> setHousehold model
        |> noEffects

    UpdateField PasswordConfirmationField value ->
      setFieldValue model.passwordConfirmation (trim value)
        |> setPasswordConfirmation model
        |> noEffects

    UpdateField PasswordField value ->
      setFieldValue model.password value
        |> setPassword model
        |> noEffects

    UpdateField UsernameField value ->
      setFieldValue model.username value
        |> clearFieldError
        |> validateNotEmpty
        |> validateUsernamePattern
        |> setUsername model
        |> checkUsernameAvailability

    UsernameAvailable ->
      clearFieldError model.username
        |> setUsername model
        |> noEffects

    UsernameNotAvailable ->
      setFieldError model.username "is not available"
        |> setUsername model
        |> noEffects


usernameAvailabilityDecoder : Json.Decode.Decoder Action
usernameAvailabilityDecoder =
  Json.Decode.object1
    (\bool ->
      case bool of
        True ->
          UsernameAvailable

        False ->
          UsernameNotAvailable
    )
    (Json.Decode.at
      [ "data", "available" ]
      Json.Decode.bool
    )


usernameHasInvalidCharacters : String -> Bool
usernameHasInvalidCharacters =
  Regex.contains (Regex.regex "[^-a-zA-Z0-9_.]+")


validate : Model -> Model
validate model =
  let
    household =
      model.household
        |> validateNotEmpty

    username =
      model.username
        |> validateNotEmpty
        |> validateUsernamePattern

    password =
      model.password
        |> validateNotEmpty

    passwordConfirmation =
      model.passwordConfirmation
        |> validateNotEmpty
  in
    { model
      | household = household
      , username = username
      , password = password
      , passwordConfirmation = passwordConfirmation
    }


validateUsernamePattern : Field -> Field
validateUsernamePattern field =
  if usernameHasInvalidCharacters field.value then
    setFieldError field "can only contain letters, numbers, periods, dashes, or underscores"
  else
    field


validateNotEmpty : Field -> Field
validateNotEmpty field =
  if field.hasError then
    field
  else if field.value |> isEmpty then
    setFieldError field " cannot be empty"
  else
    field
