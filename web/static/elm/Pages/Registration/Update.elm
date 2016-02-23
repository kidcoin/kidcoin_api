module Pages.Registration.Update (..) where

import Pages.Registration.Model exposing (..)


update : Action -> Model -> Model
update action model =
  case (Debug.log "processing registration update action" action) of
    FormSubmit ->
      redirectToLoginPageOrShowErrors model

    UpdateField HouseholdField value ->
      setFieldValue model.household value
        |> updateHouseholdInModel model

    UpdateField PasswordConfirmationField value ->
      setFieldValue model.passwordConfirmation value
        |> updatePasswordConfirmationInModel model

    UpdateField PasswordField value ->
      setFieldValue model.password value
        |> updatePasswordInModel model

    UpdateField UsernameField value ->
      setFieldValue model.username value
        |> updateUsernameInModel model


setFieldValue : Field -> String -> Field
setFieldValue field value =
  { field
    | value = value
  }


redirectToLoginPageOrShowErrors : Model -> Model
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

      False ->
        -- redirect to login page
        model'


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


usernameAvailable : Model -> Model
usernameAvailable model =
  model


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


validateField : Field -> Field
validateField field =
  if field.value == "" then
    { field
      | error = " cannot be empty"
      , hasError = True
    }
  else
    { field
      | error = ""
      , hasError = False
    }


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
