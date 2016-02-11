defmodule KidcoinApi.AccountView do
  use KidcoinApi.Web, :view

  def render("index.json", %{accounts: accounts}) do
    %{data: render_many(accounts, KidcoinApi.AccountView, "account.json")}
  end

  def render("show.json", %{account: account}) do
    %{data: render_one(account, KidcoinApi.AccountView, "account.json")}
  end

  def render("account.json", %{account: account}) do
    %{id: account.id,
      user_id: account.user_id,
      balance: account.balance}
  end
end
