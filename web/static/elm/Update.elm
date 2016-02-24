module Update (..) where

import Effects exposing (Effects, none)
import Model exposing (..)
import Pages.Home.Model
import Pages.Home.Update
import Pages.Login.Model
import Pages.Login.Update
import Pages.Registration.Model
import Pages.Registration.Update
import Routes exposing (..)
import TransitRouter


-- use mergeMany if you have other mailboxes or signals to feed into StartApp


actions : Signal Action
actions =
  Signal.map RouterAction TransitRouter.actions


initialModel : Model
initialModel =
  { transitRouter = TransitRouter.empty Routes.HomePage
  , homePageModel = Pages.Home.Model.init
  , registrationPageModel = Pages.Registration.Model.init
  , loginPageModel = Pages.Login.Model.init
  }


init : String -> ( Model, Effects Action )
init path =
  TransitRouter.init routerConfig path initialModel



-- in a typical SPA, you might have to trigger tasks when landing on a page,
-- like an HTTP request to load specific data


mountRoute : Route -> Route -> Model -> ( Model, Effects Action )
mountRoute prevRoute route model =
  case route of
    HomePage ->
      ( model, Effects.none )

    RegistrationPage ->
      ( model, Effects.none )

    LoginPage ->
      ( model, Effects.none )


routerConfig : TransitRouter.Config Route Action Model
routerConfig =
  { mountRoute = mountRoute
  , getDurations = \_ _ _ -> ( 50, 200 )
  , actionWrapper = RouterAction
  , routeDecoder = Routes.decode
  }


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NoOp ->
      noEffects model

    HomePageAction pageAction ->
      noEffects
        { model
          | homePageModel = Pages.Home.Update.update pageAction model.homePageModel
        }

    LoginPageAction pageAction ->
      noEffects
        { model
          | loginPageModel = Pages.Login.Update.update pageAction model.loginPageModel
        }

    RegistrationPageAction pageAction ->
      let
        ( registrationPageModel, nestedEffects ) =
          Pages.Registration.Update.update
            pageAction
            model.registrationPageModel

        wrappedEffects =
          Effects.map RegistrationPageAction nestedEffects
      in
        ( { model
            | registrationPageModel = registrationPageModel
          }
        , wrappedEffects
        )

    RouterAction routeAction ->
      TransitRouter.update routerConfig routeAction model


noEffects : Model -> ( Model, Effects Action )
noEffects model =
  ( model, Effects.none )
