defmodule KidcoinApi.User do
  use KidcoinApi.Web, :model

  schema "users" do
    field :guid, :string
    field :name, :string
    field :username, :string
    field :password, :string
    field :email, :string
    field :role, :integer
    belongs_to :household, KidcoinApi.Household

    timestamps
  end

  @required_fields ~w(guid name username password role)
  @optional_fields ~w(email)

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
