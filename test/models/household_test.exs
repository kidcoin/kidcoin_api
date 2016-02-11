defmodule KidcoinApi.HouseholdTest do
  use KidcoinApi.ModelCase

  alias KidcoinApi.Household

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Household.changeset(%Household{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Household.changeset(%Household{}, @invalid_attrs)
    refute changeset.valid?
  end
end
