defmodule KidcoinApi.Repo.Migrations.CreateTransaction do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :float
      add :type, :integer
      add :user_id, references(:users)
      add :account_id, references(:accounts)

      timestamps
    end
    create index(:transactions, [:user_id])
    create index(:transactions, [:account_id])

  end
end
