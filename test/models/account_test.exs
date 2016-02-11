defmodule KidcoinApi.AccountTest do
  use KidcoinApi.ModelCase

  alias KidcoinApi.Account

  @valid_attrs %{balance: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Account.changeset(%Account{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Account.changeset(%Account{}, @invalid_attrs)
    refute changeset.valid?
  end
end
