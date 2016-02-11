defmodule KidcoinApi.Account do
  use KidcoinApi.Web, :model

  schema "accounts" do
    field :balance, :integer
    belongs_to :user, KidcoinApi.User

    timestamps
  end

  @required_fields ~w(balance)
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
