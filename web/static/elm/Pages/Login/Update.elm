module Pages.Login.Update (..) where

import Pages.Login.Model exposing (..)


update : Action -> Model -> Model
update action model =
  case (Debug.log "processing login update action" action) of
    FormSubmit ->
      loginUserAndRedirect model

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


loginUserAndRedirect : Model -> Model
loginUserAndRedirect model =
  let
    model' =
      Debug.log "model after validation" <| validateFields model

    hasError =
      model'.username.hasError || model'.password.hasError
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
    username =
      validateField model.username

    password =
      validateField model.password
  in
    { model
      | username = username
      , password = password
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


updatePasswordInModel : Model -> Field -> Model
updatePasswordInModel model field =
  { model
    | password = field
  }


updateUsernameInModel : Model -> Field -> Model
updateUsernameInModel model field =
  { model
    | username = field
  }
