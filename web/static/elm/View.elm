module View (view) where

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Signal exposing (..)
import Json.Decode as Json
import TransitStyle
import TransitRouter exposing (getTransition)
import Model exposing (..)
import Routes exposing (..)
import Pages.Home.View
import Pages.Login.View
import Pages.Registration.View


content : Signal.Address Action -> Model -> Html
content address model =
  div
    [ class "content"
    , style (TransitStyle.fadeSlideLeft 10 (getTransition model))
    ]
    [ routeView address model
    ]


header : Model -> Html
header model =
  div
    [ class "header" ]
    [ menu model
    , span [ class "logo" ] []
    ]


menu : Model -> Html
menu model =
  ul
    [ class "nav nav-pills pull-right" ]
    [ menuItem HomePage "Home"
    , menuItem RegistrationPage "Register"
    , menuItem LoginPage "Login"
    ]


menuItem : Route -> String -> Html
menuItem route linkText =
  li
    []
    [ a (onClickNavigateTo <| Routes.encode route) [ text linkText ] ]


onClickNavigateTo : String -> List Attribute
onClickNavigateTo path =
  [ href path
  , onWithOptions
      "click"
      { stopPropagation = True, preventDefault = True }
      Json.value
      (\_ -> message TransitRouter.pushPathAddress path)
  ]


routeView : Signal.Address Action -> Model -> Html
routeView address model =
  case (TransitRouter.getRoute model) of
    HomePage ->
      Pages.Home.View.view (Signal.forwardTo address HomePageAction) model.homePageModel

    LoginPage ->
      Pages.Login.View.view (Signal.forwardTo address LoginPageAction) model.loginPageModel

    RegistrationPage ->
      Pages.Registration.View.view (Signal.forwardTo address RegistrationPageAction) model.registrationPageModel


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "container", attribute "role" "main" ]
    [ header model
    , content address model
    ]
