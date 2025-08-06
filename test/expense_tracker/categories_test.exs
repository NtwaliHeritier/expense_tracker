defmodule ExpenseTracker.CategoriesTest do
  use ExpenseTracker.DataCase

  alias ExpenseTracker.Categories

  setup do
    {:ok, category} =
      Categories.create_category(%{
        name: "Groceries",
        description: "Supermarket run",
        monthly_budget: Decimal.new("3000.34")
      })

    {:ok, %{category: category}}
  end

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
    test "returns a list of all categories", %{category: category} do
      assert [^category] = Categories.list_categories()
      assert category.name === "Groceries"
      assert category.description === "Supermarket run"
      assert category.monthly_budget === Decimal.new("3000.34")
    end
  end

  describe "&get_category/1" do
    test "returns an individual category", %{category: category} do
      assert ^category = Categories.get_category(category.id)
      assert category.name === "Groceries"
      assert category.description === "Supermarket run"
      assert category.monthly_budget === Decimal.new("3000.34")
    end
  end
end
