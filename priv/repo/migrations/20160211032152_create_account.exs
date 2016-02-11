defmodule KidcoinApi.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :integer
      add :user_id, references(:users)

      timestamps
    end
    create index(:accounts, [:user_id])

  end
end
