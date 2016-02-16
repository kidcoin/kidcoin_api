module Model where

import TransitRouter exposing (WithRoute)
import Routes exposing (Route)
import Pages.Home.Model exposing (Model, Action)

type alias Model = WithRoute Route
  { page : Int
  , homePageModel : Pages.Home.Model.Model
  }

type Action =
  NoOp
  | RouterAction (TransitRouter.Action Route)
  | HomePageAction Pages.Home.Model.Action
