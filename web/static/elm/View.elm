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
    ]


isCurrentRoute : Route -> Model -> Bool
isCurrentRoute route model =
  route == (TransitRouter.getRoute model)


menu : Model -> Html
menu model =
  div
    [ class "row nav" ]
    [ div [ class "column column-66" ] [ title ]
    , div
        [ class "column column-33" ]
        [ div
            [ class "row" ]
            [ menuItem model HomePage "Home"
            , menuItem model RegistrationPage "Register"
            , menuItem model LoginPage "Login"
            ]
        ]
    ]


menuItem : Model -> Route -> String -> Html
menuItem model route linkText =
  let
    navigationAttributes =
      onClickNavigateTo <| Routes.encode route

    linkClasses =
      classList
        [ ( "button", True )
        , ( "button-small", True )
        , ( "button-outline", isCurrentRoute route model )
        ]

    linkAttributes =
      navigationAttributes ++ [ linkClasses ]
  in
    div
      [ class "column" ]
      [ a linkAttributes [ text linkText ] ]


onClickNavigateTo : String -> List Attribute
onClickNavigateTo path =
  [ href path
  , onWithOptions
      "click"
      { stopPropagation = True, preventDefault = True }
      Json.value
      (\_ -> Signal.message TransitRouter.pushPathAddress path)
  ]


routeView : Signal.Address Action -> Model -> Html
routeView address model =
  case (TransitRouter.getRoute model) of
    HomePage ->
      Pages.Home.View.view
        (Signal.forwardTo address HomePageAction)
        model.homePageModel

    LoginPage ->
      Pages.Login.View.view
        (Signal.forwardTo address LoginPageAction)
        model.loginPageModel

    RegistrationPage ->
      Pages.Registration.View.view
        (Signal.forwardTo address RegistrationPageAction)
        model.registrationPageModel


title : Html
title =
  h3 [ class "color-primary" ] [ text "KidCoin" ]


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "container", attribute "role" "main" ]
    [ header model
    , content address model
    ]
