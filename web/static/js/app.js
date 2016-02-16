import "phoenix_html"
import Elm from "../elm/App.elm"

const elm_div = document.getElementById("elm-main")
const elm_app = Elm.embed(Elm.App, elm_div)
