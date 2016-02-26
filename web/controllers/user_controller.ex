defmodule KidcoinApi.UserController do
  use KidcoinApi.Web, :controller
  require Logger

  import Ecto.Query, only: [select: 3, where: 2]
  import Ecto.Query.API, only: [count: 1]
  alias KidcoinApi.User

  plug :scrub_params, "user" when action in [:create, :update]

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(KidcoinApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def check_availability(conn, %{"username" => username}) do
    username = clean_username(username)
    available = username_available?(username)
    render(conn, "check_availability.json", username: username, available: available)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(KidcoinApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end

  defp clean_username(username) do
    username
    |> String.downcase
    |> String.strip
  end

  defp username_available?(username) when is_binary(username) do
    count = User
            |> where(username: ^username)
            |> select([u], count(u.id))
            |> Repo.one
            |> username_available?
  end

  defp username_available?(0),
  do: true

  defp username_available?(count) when is_integer(count) and count != 0,
  do: false

end
