defmodule KidcoinApi.HouseholdView do
  use KidcoinApi.Web, :view

  def render("index.json", %{households: households}) do
    %{data: render_many(households, KidcoinApi.HouseholdView, "household.json")}
  end

  def render("show.json", %{household: household}) do
    %{data: render_one(household, KidcoinApi.HouseholdView, "household.json")}
  end

  def render("household.json", %{household: household}) do
    %{id: household.id,
      name: household.name}
  end
end
