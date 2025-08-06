defmodule ExpenseTracker.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :description, :text, null: false
      add :monthly_budget, :decimal, precision: 10, scale: 2, null: false
      add :total_spendings, :decimal, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:categories, [:id])
  end
end
