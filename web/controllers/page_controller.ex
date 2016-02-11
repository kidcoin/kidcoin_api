defmodule KidcoinApi.PageController do
  use KidcoinApi.Web, :controller

  alias KidcoinApi.User

  def index(conn, _params) do
    conn
    |> assign(:users, Repo.all(User))
    |> render("index.html")
  end
end
