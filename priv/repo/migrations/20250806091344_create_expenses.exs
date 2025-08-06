defmodule ExpenseTracker.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add :description, :text, null: false
      add :amount, :decimal, null: false
      add :date, :date, null: false
      add :notes, :text
      add :category_id, references(:categories, on_delete: :nilify_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:expenses, [:category_id])
    create index(:expenses, [:id])
  end
end
