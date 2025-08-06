# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ExpenseTracker.Repo.insert!(%ExpenseTracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ExpenseTracker.Categories
alias ExpenseTracker.Expenses

{:ok, supermarket_category} =
  Categories.create_category(%{
    name: "Groceries",
    description: "Supermarket run",
    monthly_budget: Decimal.new("3000.34")
  })

{:ok, transportation_category} =
  Categories.create_category(%{
    name: "Transportation",
    description: "Travel fees",
    monthly_budget: Decimal.new("1000.34")
  })

attrs = %{
  "description" => "Wallmart run",
  "amount" => Decimal.new("25.6"),
  "category" => supermarket_category
}

{:ok, _} = Expenses.add_expense_to_category(attrs)

attrs = %{
  "description" => "Uber fee",
  "amount" => Decimal.new("25.6"),
  "category" => transportation_category
}

{:ok, _} = Expenses.add_expense_to_category(attrs)
