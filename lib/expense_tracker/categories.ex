defmodule ExpenseTracker.Categories do
  alias ExpenseTracker.Categories.Category
  alias ExpenseTracker.Repo

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def list_categories() do
    Repo.all(Category)
  end

  def get_category(id) do
    Repo.get(Category, id)
  end
end
