defmodule KidcoinApi.Transaction do
  use KidcoinApi.Web, :model

  schema "transactions" do
    field :amount, :float
    field :type, :integer
    belongs_to :user, KidcoinApi.User
    belongs_to :account, KidcoinApi.Account

    timestamps
  end

  @required_fields ~w(amount type)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
