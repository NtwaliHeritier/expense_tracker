defmodule ExpenseTracker.CategorySupport do
  alias ExpenseTracker.Categories

  def create_category(_opts \\ []) do
    {:ok, category} =
      Categories.create_category(%{
        name: "Groceries",
        description: "Supermarket run",
        monthly_budget: Decimal.new("3000.34")
      })

    %{category: category}
  end
end
