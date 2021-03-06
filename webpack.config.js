var ExtractTextPlugin = require("extract-text-webpack-plugin");
var CopyWebpackPlugin = require("copy-webpack-plugin");

module.exports = {
  devtool: "source-map",

  entry: {
    "app": ["./web/static/css/app.scss", "./web/static/elm/App.elm", "./web/static/js/app.js"],
  },

  output: {
    path: "./priv/static",
    filename: "js/app.js"
  },

  resolve: {
    modulesDirectories: [ __dirname + "/web/static/js" ],
    alias: {
      phoenix: __dirname + "/deps/phoenix/web/static/js/phoenix.js",
      phoenix_html: __dirname + "/deps/phoenix_html/web/static/js/phoenix_html.js",
    }
  },

  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "babel",
        query: {
          presets: ["es2015"]
        }
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: "elm-webpack"
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract("style", "css")
      },
      {
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract(
          "style",
          "css!sass?includePaths[]=" + __dirname +  "/node_modules"
        )
      }
    ],
    noParse: [/.elm$/]
  },

  plugins: [
    new ExtractTextPlugin("css/app.css"),
    new CopyWebpackPlugin([
      { from: "./web/static/assets" },
      { from: "./deps/phoenix_html/web/static/js/phoenix_html.js",
        to: "js/phoenix_html.js" }
    ])
  ]
}
