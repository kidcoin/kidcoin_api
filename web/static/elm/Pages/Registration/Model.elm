module Pages.Registration.Model (..) where

import Regex


type Action
  = FormSubmit
  | UpdateField FieldType String
  | UsernameAvailability Bool


type FieldType
  = EmailField
  | HouseholdField
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
  { email : Field
  , household : Field
  , username : Field
  , password : Field
  , passwordConfirmation : Field
  }


clearFieldError : Field -> Field
clearFieldError field =
  { field
    | error = ""
    , hasError = False
  }


emailPattern : Regex.Regex
emailPattern =
  Regex.regex "\\S+@\\S+\\.\\S+"


init : Model
init =
  Model
    (Field EmailField "" "" False)
    (Field HouseholdField "" "" False)
    (Field UsernameField "" "" False)
    (Field PasswordField "" "" False)
    (Field PasswordConfirmationField "" "" False)


invalidUsernamePattern : Regex.Regex
invalidUsernamePattern =
  Regex.regex "[^-a-zA-Z0-9_.]+"


isEmailValid : String -> Bool
isEmailValid email =
  email
    |> Regex.contains emailPattern


isUsernameValid : String -> Bool
isUsernameValid username =
  username
    |> Regex.contains invalidUsernamePattern
    |> not


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
