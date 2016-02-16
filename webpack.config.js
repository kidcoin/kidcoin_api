// Configuration gotten from:
// http://matthewlehner.net/using-webpack-with-phoenix-and-elixir/

var CopyWebpackPlugin = require("copy-webpack-plugin");
var ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = {
  entry: ["./web/static/js/app.js", "./web/static/css/app.css"],

  output: {
    path: "./priv/static/js",
    filename: "app.js"
  },

  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loaders: ["babel"],
        include: __dirname
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract("css")
      }
    ]
  },

  plugins: [
    new CopyWebpackPlugin([{ from: "./web/static/assets" }]),
    new ExtractTextPlugin("css/app.css")
  ],

  resolve: {
    modulesDirectories: [ __dirname + "/web/static/js" ],
    alias: {
      phoenix_html:
        __dirname + "/deps/phoenix_html/web/static/js/phoenix_html.js",
      phoenix:
        __dirname + "/deps/phoenix/web/static/js/phoenix.js"
    }
  }

};
