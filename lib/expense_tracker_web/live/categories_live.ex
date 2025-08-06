defmodule ExpenseTrackerWeb.CategoriesLive do
  use ExpenseTrackerWeb, :live_view

  alias ExpenseTracker.Categories

  def mount(_params, _session, socket) do
    categories = Categories.list_categories()
    {:ok, socket |> assign(%{categories: categories})}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-center text-bold mt-5">Categories list</h1>
    <ul class="mx-5">
      <li :for={category <- @categories}>
        <.link navigate={~p"/categories/#{category.id}"} class="capitalize">
          <h3 class="mb-3 underline underline-offset-4">{category.name}</h3>
          <span>{category.description}</span>
        </.link>
      </li>
    </ul>
    """
  end
end
