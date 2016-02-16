module Routes (..) where

import Effects exposing (..)
import RouteParser exposing (..)
import TransitRouter


type Route
  = HomePage
  | LoginPage
  | RegistrationPage


routeParsers : List (Matcher Route)
routeParsers =
  [ static HomePage "/"
  , static RegistrationPage "/register"
  , static LoginPage "/login"
  ]


decode : String -> Route
decode path =
  RouteParser.match routeParsers path
    |> Maybe.withDefault HomePage


encode : Route -> String
encode route =
  case route of
    HomePage ->
      "/"

    LoginPage ->
      "/login"

    RegistrationPage ->
      "/register"


redirect : Route -> Effects ()
redirect route =
  encode route
    |> Signal.send TransitRouter.pushPathAddress
    |> Effects.task
