defmodule KidcoinApi.Repo.Migrations.CreateHousehold do
  use Ecto.Migration

  def change do
    create table(:households) do
      add :name, :string

      timestamps
    end

  end
end
