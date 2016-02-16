module Routes where

import Effects exposing (..)
import RouteParser exposing (..)
import TransitRouter

type Route =
    HomePage
    | RegistrationPage
    | LoginPage
    | EmptyRoute

routeParsers : List (Matcher Route)
routeParsers =
    [ static HomePage "/"
    , static RegistrationPage "/register"
    , static LoginPage "/login"
    ]

decode : String -> Route
decode path =
    RouteParser.match routeParsers path
    |> Maybe.withDefault EmptyRoute

encode : Route -> String
encode route =
    case route of
        HomePage -> "/"
        RegistrationPage -> "/register"
        LoginPage -> "/login"
        EmptyRoute -> ""

redirect : Route -> Effects ()
redirect route =
    encode route
    |> Signal.send TransitRouter.pushPathAddress
    |> Effects.task
