defmodule KidcoinApi.TransactionTest do
  use KidcoinApi.ModelCase

  alias KidcoinApi.Transaction

  @valid_attrs %{amount: "120.5", type: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Transaction.changeset(%Transaction{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Transaction.changeset(%Transaction{}, @invalid_attrs)
    refute changeset.valid?
  end
end
