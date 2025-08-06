defmodule ExpenseTracker.Expenses do
  alias ExpenseTracker.Categories
  alias ExpenseTracker.Expenses.Expense
  alias ExpenseTracker.Repo

  import Ecto.Query

  # def add_expense_to_category(%{"category_id" => category_id, "amount" => amount} = attrs) do
  #   changeset = change_expense(%Expense{}, attrs)

  #   case changeset do
  #     %Ecto.Changeset{valid?: true} ->
  #       category = Categories.get_category(category_id)
  #       new_total_spendings = Decimal.add(category.total_spendings, amount)

  #       if Decimal.compare(category.monthly_budget, new_total_spendings) === :gt do
  #         Repo.transact(fn ->
  #           {:ok, expense} = create_expense(attrs)

  #           {:ok, category} =
  #             Categories.update_category(category, %{total_spendings: new_total_spendings})

  #           {:ok, [expense, category]}
  #         end)
  #       else
  #         {:error,
  #          changeset
  #          |> Ecto.Changeset.add_error(:amount, "Expenses cannot exceed monthly budget")
  #          |> Map.put(:action, :insert)}
  #       end

  #     _ ->
  #       changeset |> Map.put(:action, :insert)
  #   end
  # end

  def add_expense_to_category(%{"category" => category, "amount" => amount} = attrs) do
    attrs = Map.put(attrs, "category_id", category.id)
    changeset = change_expense(%Expense{}, attrs)

    case changeset do
      %Ecto.Changeset{valid?: true} ->
        new_total_spendings = Decimal.add(category.total_spendings, amount)

        if Decimal.compare(category.monthly_budget, new_total_spendings) === :gt do
          Repo.transact(fn ->
            {:ok, expense} = create_expense(attrs)

            {:ok, category} =
              Categories.update_category(category, %{total_spendings: new_total_spendings})

            {:ok, [expense, category]}
          end)
        else
          {:error,
           changeset
           |> Ecto.Changeset.add_error(:amount, "Expenses cannot exceed monthly budget")
           |> Map.put(:action, :insert)}
        end

      _ ->
        changeset |> Map.put(:action, :insert)
    end
  end

  def create_expense(attrs) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> Repo.insert()
  end

  def change_expense(%Expense{} = expense, attrs \\ %{}) do
    Expense.changeset(expense, attrs)
  end

  def get_recent_category_expense(category_id) do
    Expense
    |> where([e], e.category_id == ^category_id)
    |> order_by(desc: :id)
    |> limit(1)
    |> Repo.one()
  end
end
