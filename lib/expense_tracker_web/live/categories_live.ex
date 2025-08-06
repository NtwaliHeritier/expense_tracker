defmodule ExpenseTrackerWeb.CategoriesLive do
  use ExpenseTrackerWeb, :live_view

  alias ExpenseTracker.Categories

  def mount(_params, _session, socket) do
    categories = Categories.list_categories()
    {:ok, socket |> assign(%{categories: categories})}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-center text-bold">Categories list</h1>
    <ul>
      <li :for={category <- @categories}>
        <.link navigate={~p"/categories/#{category.id}"} class="capitalize">{category.name}</.link>
      </li>
    </ul>
    """
  end
end
