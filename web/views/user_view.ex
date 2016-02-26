defmodule KidcoinApi.UserView do
  use KidcoinApi.Web, :view

  def render("check_availability.json", %{username: username, available: available}) do
    %{data: %{username: username, available: available}}
  end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, KidcoinApi.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, KidcoinApi.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      household_id: user.household_id,
      guid: user.guid,
      name: user.name,
      username: user.username,
      password: user.password,
      email: user.email,
      role: user.role}
  end
end
