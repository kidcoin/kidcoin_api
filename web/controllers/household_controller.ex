defmodule KidcoinApi.HouseholdController do
  use KidcoinApi.Web, :controller

  alias KidcoinApi.Household

  plug :scrub_params, "household" when action in [:create, :update]

  def index(conn, _params) do
    households = Repo.all(Household)
    render(conn, "index.json", households: households)
  end

  def create(conn, %{"household" => household_params}) do
    changeset = Household.changeset(%Household{}, household_params)

    case Repo.insert(changeset) do
      {:ok, household} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", household_path(conn, :show, household))
        |> render("show.json", household: household)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(KidcoinApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    household = Repo.get!(Household, id)
    render(conn, "show.json", household: household)
  end

  def update(conn, %{"id" => id, "household" => household_params}) do
    household = Repo.get!(Household, id)
    changeset = Household.changeset(household, household_params)

    case Repo.update(changeset) do
      {:ok, household} ->
        render(conn, "show.json", household: household)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(KidcoinApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    household = Repo.get!(Household, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(household)

    send_resp(conn, :no_content, "")
  end
end
