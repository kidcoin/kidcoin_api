defmodule KidcoinApi.ElmController do
  use KidcoinApi.Web, :controller

  alias KidcoinApi.User

  def app(conn, _params) do
    conn
    |> assign(:users, Repo.all(User))
    |> render("app.html")
  end
end
