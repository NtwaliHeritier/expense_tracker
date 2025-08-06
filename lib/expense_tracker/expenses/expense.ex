defmodule ExpenseTracker.Expenses.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  alias ExpenseTracker.Categories.Category

  schema "expenses" do
    field :date, :date
    field :description, :string
    field :amount, :decimal
    field :notes, :string
    belongs_to :category, Category

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:description, :amount, :date, :notes, :category_id])
    |> validate_required([:description, :amount, :category_id])
    |> add_expense_date()
  end

  defp add_expense_date(changeset) do
    change(changeset, %{date: Date.utc_today()})
  end
end
