module Pages.Registration.Model (..) where


type Action
  = FormSubmit
  | UpdateField FieldType String
  | UsernameAvailable
  | UsernameNotAvailable


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
  , usernameAvailable : Bool
  , password : Field
  , passwordConfirmation : Field
  }


init : Model
init =
  Model
    (Field HouseholdField "" "" False)
    (Field UsernameField "" "" False)
    True
    (Field PasswordField "" "" False)
    (Field PasswordConfirmationField "" "" False)
