defmodule ExpenseTracker.ExpensesTest do
  use ExpenseTracker.DataCase

  alias ExpenseTracker.Expenses

  import ExpenseTracker.CategorySupport, only: [create_category: 1]

  describe "&add_expense_to_category/1" do
    setup [:create_category]

    test "adds expense to category and updates category total_spendings", %{category: category} do
      attrs = %{
        date: Date.utc_today(),
        description: "Wallmart run",
        amount: Decimal.new("25.6"),
        category_id: category.id
      }

      assert category.total_spendings === Decimal.new("0")
      assert {:ok, [expense, category]} = Expenses.add_expense_to_category(attrs)
      assert category.total_spendings === Decimal.new("25.6")
      assert expense.description === "Wallmart run"
      assert expense.amount === Decimal.new("25.6")
    end

    test "returns an error when total_spendings exceeds the monthly budget", %{category: category} do
      attrs = %{
        date: Date.utc_today(),
        description: "Shopping spree",
        amount: Decimal.new("4000"),
        category_id: category.id
      }

      assert category.total_spendings === Decimal.new("0")

      assert {:error, "Expenses cannot exceed montly budget"} =
               Expenses.add_expense_to_category(attrs)

      assert category.total_spendings === Decimal.new("0")
    end
  end
end
