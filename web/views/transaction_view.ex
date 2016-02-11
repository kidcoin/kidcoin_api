defmodule KidcoinApi.TransactionView do
  use KidcoinApi.Web, :view

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, KidcoinApi.TransactionView, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, KidcoinApi.TransactionView, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{id: transaction.id,
      user_id: transaction.user_id,
      account_id: transaction.account_id,
      amount: transaction.amount,
      type: transaction.type}
  end
end
