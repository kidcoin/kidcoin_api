module Pages.Registration.Model (..) where


type Availability
  = Available
  | NotAvailable
  | NotChecked


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
  , password : Field
  , passwordConfirmation : Field
  , isUsernameAvailable : Availability
  }


init : Model
init =
  Model
    (Field HouseholdField "" "" False)
    (Field UsernameField "" "" False)
    (Field PasswordField "" "" False)
    (Field PasswordConfirmationField "" "" False)
    NotChecked
