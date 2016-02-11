defmodule KidcoinApi.HouseholdControllerTest do
  use KidcoinApi.ConnCase

  alias KidcoinApi.Household
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, household_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    household = Repo.insert! %Household{}
    conn = get conn, household_path(conn, :show, household)
    assert json_response(conn, 200)["data"] == %{"id" => household.id,
      "name" => household.name}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, household_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, household_path(conn, :create), household: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Household, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, household_path(conn, :create), household: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    household = Repo.insert! %Household{}
    conn = put conn, household_path(conn, :update, household), household: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Household, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    household = Repo.insert! %Household{}
    conn = put conn, household_path(conn, :update, household), household: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    household = Repo.insert! %Household{}
    conn = delete conn, household_path(conn, :delete, household)
    assert response(conn, 204)
    refute Repo.get(Household, household.id)
  end
end
