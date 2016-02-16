module Model (..) where

import TransitRouter exposing (WithRoute)
import Routes exposing (Route)
import Pages.Home.Model
import Pages.Registration.Model
import Pages.Login.Model


type alias Model =
  WithRoute
    Route
    { homePageModel : Pages.Home.Model.Model
    , loginPageModel : Pages.Login.Model.Model
    , registrationPageModel : Pages.Registration.Model.Model
    }


type Action
  = NoOp
  | RouterAction (TransitRouter.Action Route)
  | HomePageAction Pages.Home.Model.Action
  | LoginPageAction Pages.Login.Model.Action
  | RegistrationPageAction Pages.Registration.Model.Action
