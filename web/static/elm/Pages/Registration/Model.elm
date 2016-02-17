module Pages.Registration.Model (Model, Action, init) where


type Action
  = None
  | Submit


type alias Model =
  { name : String
  , password : String
  , password_confirmation : String
  , username : String
  }


init : Model
init =
  Model "" "" "" ""
