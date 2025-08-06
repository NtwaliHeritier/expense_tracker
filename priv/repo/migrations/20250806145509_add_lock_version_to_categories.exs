defmodule ExpenseTracker.Repo.Migrations.AddLockVersionToCategories do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :lock_version, :integer, default: 1, null: false
    end
  end
end
