defmodule KidcoinApi.AccountControllerTest do
  use KidcoinApi.ConnCase

  alias KidcoinApi.Account
  @valid_attrs %{balance: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, account_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    account = Repo.insert! %Account{}
    conn = get conn, account_path(conn, :show, account)
    assert json_response(conn, 200)["data"] == %{"id" => account.id,
      "user_id" => account.user_id,
      "balance" => account.balance}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, account_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, account_path(conn, :create), account: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Account, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, account_path(conn, :create), account: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    account = Repo.insert! %Account{}
    conn = put conn, account_path(conn, :update, account), account: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Account, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    account = Repo.insert! %Account{}
    conn = put conn, account_path(conn, :update, account), account: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    account = Repo.insert! %Account{}
    conn = delete conn, account_path(conn, :delete, account)
    assert response(conn, 204)
    refute Repo.get(Account, account.id)
  end
end