module App (..) where

import Effects exposing (Never)
import Signal
import StartApp
import Task
import Update exposing (init, update, actions)
import View exposing (view)


port initialPath : String


app =
    StartApp.start
        { init = init initialPath
        , update = update
        , view = view
        , inputs = [ actions ]
        }


main =
    app.html


port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks
