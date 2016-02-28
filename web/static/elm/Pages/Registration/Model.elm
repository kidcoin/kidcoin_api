module Pages.Registration.Model (..) where

import Regex


type Action
  = FormSubmit
  | UpdateField FieldType String
  | UsernameAvailability Bool


type FieldType
  = HouseholdField
  | UsernameField
  | PasswordField
  | PasswordConfirmationField


type alias Field =
  { fieldType : FieldType
  , value : String
  , error : String
  , hasError : Bool
  }


type alias Model =
  { household : Field
  , username : Field
  , password : Field
  , passwordConfirmation : Field
  }


init : Model
init =
  Model
    (Field HouseholdField "" "" False)
    (Field UsernameField "" "" False)
    (Field PasswordField "" "" False)
    (Field PasswordConfirmationField "" "" False)


isUsernameValid : String -> Bool
isUsernameValid username =
  username
    |> Regex.contains usernamePattern


clearFieldError : Field -> Field
clearFieldError field =
  { field
    | error = ""
    , hasError = False
  }


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


usernamePattern : Regex.Regex
usernamePattern =
  Regex.regex "[^-a-zA-Z0-9_.]+"
