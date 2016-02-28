module Pages.Registration.Update (..) where

import Api.User
import Effects exposing (Effects, none)
import Pages.Registration.Model exposing (..)
import Regex
import String exposing (isEmpty, trim)


checkUsernameAvailability : Model -> ( Model, Effects Action )
checkUsernameAvailability model =
  let
    effect =
      if model.username.hasError then
        Effects.none
      else
        Api.User.isUsernameAvailable
          model.username.value
          UsernameAvailable
          UsernameNotAvailable
  in
    ( model, effect )


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


submitFormIfValid : Model -> ( Model, Effects Action )
submitFormIfValid model =
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
        -- submit form
        model'
          |> withFormSubmitEffects


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case (Debug.log "processing registration update action" action) of
    FormSubmit ->
      submitFormIfValid model

    UpdateField HouseholdField value ->
      setFieldValue model.household (trim value)
        |> setHousehold model
        |> noEffects

    UpdateField PasswordConfirmationField value ->
      setFieldValue model.passwordConfirmation (trim value)
        |> clearFieldError
        |> setPasswordConfirmation model
        |> validatePasswordsMatch
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

    model' =
      { model
        | household = household
        , username = username
        , password = password
        , passwordConfirmation = passwordConfirmation
      }
  in
    model'
      |> validatePasswordsMatch


validatePasswordsMatch : Model -> Model
validatePasswordsMatch model =
  if model.password.hasError || model.passwordConfirmation.hasError then
    model
  else
    let
      passwordsMatch =
        model.password.value == model.passwordConfirmation.value
    in
      if passwordsMatch then
        model
      else
        setFieldError model.passwordConfirmation "does not match your Password"
          |> setPasswordConfirmation model


validateUsernamePattern : Field -> Field
validateUsernamePattern field =
  if field.hasError then
    field
  else if isUsernameValid field.value then
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


withFormSubmitEffects : Model -> ( Model, Effects Action )
withFormSubmitEffects model =
  ( model, Effects.none )
