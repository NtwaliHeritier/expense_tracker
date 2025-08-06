defmodule ExpenseTracker.ExpensesTest do
  use ExpenseTracker.DataCase

  alias ExpenseTracker.Expenses

  import ExpenseTracker.CategorySupport, only: [create_category: 1]

  describe "&add_expense_to_category/1" do
    setup [:create_category]

    test "adds expense to category and updates category total_spendings", %{category: category} do
      attrs = %{
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

  describe "&get_latest_expense_by_category_id/1" do
    setup [:create_category]

    test "returns latest expense record by category", %{category: category} do
      attrs1 = %{
        description: "Wallmart run",
        amount: Decimal.new("25.6"),
        category_id: category.id
      }

      attrs2 = %{
        description: "McDonalds order",
        amount: Decimal.new("29.6"),
        category_id: category.id
      }

      assert {:ok, [_expense1, _category]} = Expenses.add_expense_to_category(attrs1)
      assert {:ok, [expense2, _category]} = Expenses.add_expense_to_category(attrs2)

      expense = Expenses.get_recent_category_expense(category.id)
      assert expense.id === expense2.id
    end
  end
end
