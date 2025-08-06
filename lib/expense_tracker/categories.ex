defmodule ExpenseTracker.Categories do
  alias ExpenseTracker.Categories.Category
  alias ExpenseTracker.Repo

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:category_created)
  end

  def list_categories() do
    Repo.all(Category)
  end

  def get_category(id) do
    Repo.get(Category, id)
  end

  def update_category(category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  def broadcast({:ok, category}, tag) do
    Phoenix.PubSub.broadcast(
      ExpenseTracker.PubSub,
      "categories",
      {tag, category}
    )

    {:ok, category}
  end

  def broadcast({:error, _reason} = error, _tag), do: error

  def subscribe do
    Phoenix.PubSub.subscribe(ExpenseTracker.PubSub, "categories")
  end
end
