defmodule KidcoinApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :guid, :string
      add :name, :string
      add :username, :string
      add :password, :string
      add :email, :string
      add :role, :integer
      add :household_id, references(:households)

      timestamps
    end
    create index(:users, [:household_id])

  end
end
