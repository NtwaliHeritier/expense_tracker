defmodule ExpenseTrackerWeb.CategoriesLive do
  use ExpenseTrackerWeb, :live_view

  alias ExpenseTracker.Categories
  alias ExpenseTracker.Categories.Category

  def mount(_params, _session, socket) do
    if connected?(socket), do: Categories.subscribe()

    categories = Categories.list_categories()
    changeset = Categories.change_category(%Category{})
    {:ok, socket |> assign(%{form: to_form(changeset)}) |> stream(:categories, categories)}
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-center text-bold mt-5">Categories list</h1>
    <.link patch={~p"/categories/new"}>
      <h3 class="text-right mr-8 mt-5">Add New Category</h3>
    </.link>
    <ul class="mx-5 mt-3" phx-update="stream" id="stream-id">
      <li :for={{dom_id, category} <- @streams.categories} id={dom_id} class="mb-3">
        <.link navigate={~p"/categories/#{category.id}"} class="capitalize">
          <h3 class="underline underline-offset-4 mb-3">{category.name}</h3>
          <div class="mb-3">
            <span>{category.description}</span>
          </div>
        </.link>
        <hr />
      </li>
    </ul>
    <.modal :if={@live_action == :new} id="new-category" show on_cancel={JS.patch(~p"/categories")}>
      <.form for={@form} phx-submit="save">
        <.input field={@form[:name]} placeholder="Name" />
        <.input field={@form[:description]} placeholder="Description" />
        <.input field={@form[:monthly_budget]} placeholder="Monthly budget" />
        <.button class="mt-2">
          Save
        </.button>
      </.form>
    </.modal>
    """
  end

  def handle_event("save", %{"category" => params}, socket) do
    case Categories.create_category(params) do
      {:ok, _category} ->
        {:noreply, push_patch(socket, to: ~p"/categories")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_info({:category_created, category}, socket) do
    {:noreply, stream_insert(socket, :categories, category, at: 0)}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
