defmodule ExpenseTracker.Expenses do
  alias ExpenseTracker.Categories
  alias ExpenseTracker.Expenses.Expense
  alias ExpenseTracker.Repo

  import Ecto.Query

  def add_expense_to_category(%{category_id: category_id, amount: amount} = attrs) do
    category = Categories.get_category(category_id)

    new_total_spendings = Decimal.add(category.total_spendings, amount)

    case Decimal.compare(category.monthly_budget, new_total_spendings) do
      :gt ->
        Repo.transact(fn ->
          {:ok, expense} = create_expense(attrs)

          {:ok, category} =
            Categories.update_category(category, %{total_spendings: new_total_spendings})

          {:ok, [expense, category]}
        end)

      _ ->
        {:error, "Expenses cannot exceed montly budget"}
    end
  end

  def create_expense(attrs) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> Repo.insert()
  end

  def get_latest_expense_by_category_id(category_id) do
    Expense
    |> where([e], e.category_id == ^category_id)
    |> order_by(desc: :id)
    |> limit(1)
    |> Repo.one()
  end
end
