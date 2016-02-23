module Pages.Login.Model (..) where


type Action
  = FormSubmit
  | UpdateField FieldType String


type FieldType
  = UsernameField
  | PasswordField


type alias Field =
  { fieldType : FieldType
  , value : String
  , error : String
  , hasError : Bool
  }


type alias Model =
  { username : Field
  , password : Field
  }


init : Model
init =
  Model
    (Field UsernameField "" "" False)
    (Field PasswordField "" "" False)
