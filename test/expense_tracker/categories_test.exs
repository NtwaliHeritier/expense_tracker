defmodule ExpenseTracker.CategoriesTest do
  use ExpenseTracker.DataCase

  alias ExpenseTracker.Categories

  import ExpenseTracker.CategorySupport, only: [create_category: 1]

  describe "&create_category/1" do
    test "creates a category" do
      assert {:ok, category} =
               Categories.create_category(%{
                 name: "Transportation",
                 description: "Monthly transport fees",
                 monthly_budget: Decimal.new("1000.34")
               })

      assert category.name === "Transportation"
      assert category.description === "Monthly transport fees"
      assert category.monthly_budget === Decimal.new("1000.34")
      assert category.total_spendings === Decimal.new("0")
    end

    test "returns an ecto error when a required field is ommitted" do
      assert {:error, %Ecto.Changeset{valid?: false}} =
               Categories.create_category(%{
                 description: "Monthly transport fees",
                 monthly_budget: Decimal.new("1000.34")
               })
    end
  end

  describe "&list_categories/0" do
    setup [:create_category]

    test "returns a list of all categories", %{category: category} do
      assert [^category] = Categories.list_categories()
      assert category.name === "Groceries"
      assert category.description === "Supermarket run"
      assert category.monthly_budget === Decimal.new("3000.34")
      assert category.total_spendings === Decimal.new("0")
    end
  end

  describe "&get_category/1" do
    setup [:create_category]

    test "returns an individual category", %{category: category} do
      assert ^category = Categories.get_category(category.id)
      assert category.name === "Groceries"
      assert category.description === "Supermarket run"
      assert category.monthly_budget === Decimal.new("3000.34")
      assert category.total_spendings === Decimal.new("0")
    end
  end

  describe "&update/2" do
    setup [:create_category]

    test "updates a category", %{category: category} do
      assert {:ok, category} = Categories.update_category(category, %{name: "Rent"})
      assert category.name === "Rent"
    end

    test "returns an ecto error when total spendings exceeds monthly budget", %{
      category: category
    } do
      assert {:error,
              %Ecto.Changeset{
                valid?: false,
                errors: [total_spendings: {"Total spendings cannot exceed monthly budget", []}]
              }} =
               Categories.update_category(category, %{total_spendings: Decimal.new("4000")})
    end

    test "returns an ecto error when monthly budget is negative or zero", %{
      category: category
    } do
      assert {:error,
              %Ecto.Changeset{
                valid?: false,
                errors: [monthly_budget: {"Monthly budget can't be zero or negative", []}]
              }} =
               Categories.update_category(category, %{monthly_budget: Decimal.new("0")})
    end
  end
end
