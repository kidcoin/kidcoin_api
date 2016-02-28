module Pages.Registration.Update (..) where

import Api.User exposing (isUsernameAvailable)
import Effects exposing (Effects)
import Pages.Registration.Model exposing (..)
import String exposing (isEmpty, trim)


checkUsernameAvailability : Model -> ( Model, Effects Action )
checkUsernameAvailability model =
  let
    effect =
      if model.username.hasError then
        Effects.none
      else
        isUsernameAvailable
          model.username.value
          UsernameAvailability
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


setEmail : Model -> Field -> Model
setEmail model field =
  { model
    | email = field
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
      model'.email.hasError
        || model'.household.hasError
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

    UpdateField EmailField value ->
      setFieldValue model.email value
        |> clearFieldError
        |> validateNotEmpty
        |> validateEmailPattern
        |> setEmail model
        |> noEffects

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

    UsernameAvailability True ->
      clearFieldError model.username
        |> setUsername model
        |> noEffects

    UsernameAvailability False ->
      setFieldError model.username "is not available"
        |> setUsername model
        |> noEffects

    RegistrationSuccess response ->
      -- redirect to login
      model
        |> noEffects

    RegistrationFailed response ->
      -- redirect to login
      model
        |> noEffects


validate : Model -> Model
validate model =
  let
    email =
      model.email
        |> validateNotEmpty
        |> validateEmailPattern

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
        | email = email
        , household = household
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


validateEmailPattern : Field -> Field
validateEmailPattern field =
  if field.hasError then
    field
  else if not <| isEmailValid field.value then
    setFieldError field "is invalid"
  else
    field


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
