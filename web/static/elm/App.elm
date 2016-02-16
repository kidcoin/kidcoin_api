module App where

import Html exposing (..)
import Html.Attributes exposing (..)

main : Html
main =
    div [] [ top,
    bottom ]

top : Html
top =
    div [ class "jumbotron" ]
    [ h2 []
    [ text "Welcome to Kidcoin!" ]
    , p [ class "lead" ]
    [ text "A place to give kids coins." ]
    , p []
    [ h2 []
    [ text "Users" ]
    , ul []
    [ li []
    [ text "User name" ]
    ]
    ]
    ]

bottom : Html
bottom =
    div [ class "row marketing" ]
    [ div [ class "col-lg-6" ]
    [ h4 []
    [ text "Resources" ]
    , ul []
    [ li []
    [ a [ href "http://phoenixframework.org/docs/overview" ]
    [ text "Guides" ]
    ]
    , li []
    [ a [ href "http://hexdocs.pm/phoenix" ]
    [ text "Docs" ]
    ]
    , li []
    [ a [ href "https://github.com/phoenixframework/phoenix" ]
    [ text "Source" ]
    ]
    ]
    ]
    , div [ class "col-lg-6" ]
    [ h4 []
    [ text "Help" ]
    , ul []
    [ li []
    [ a [ href "http://groups.google.com/group/phoenix-talk" ]
    [ text "Mailing list" ]
    ]
    , li []
    [ a [ href "http://webchat.freenode.net/?channels=elixir-lang" ]
    [ text "#elixir-lang on freenode IRC" ]
    ]
    , li []
    [ a [ href "https://twitter.com/elixirphoenix" ]
    [ text "@elixirphoenix" ]
    ]
    ]
    ]
    ]
