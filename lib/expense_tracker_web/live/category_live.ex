defmodule ExpenseTrackerWeb.CategoryLive do
  use ExpenseTrackerWeb, :live_view

  alias ExpenseTracker.Categories
  alias ExpenseTracker.Expenses
  alias ExpenseTracker.Expenses.Expense

  def mount(%{"category_id" => category_id}, _session, socket) do
    category = Categories.get_category(category_id)
    changeset = Expenses.change_expense(%Expense{})

    spendings_percentage = get_percentage(category)

    recent_expense = Expenses.get_recent_category_expense(category_id)

    {:ok,
     socket
     |> assign(%{
       category: category,
       spendings_percentage: spendings_percentage,
       recent_expense: recent_expense,
       category_id: category_id,
       form: to_form(changeset)
     })}
  end

  def render(assigns) do
    ~H"""
    <.link navigate={~p"/categories"}>
      <h1 class="mt-5 pl-8 underline underline-offset-4">All Categories</h1>
    </.link>
    <.link patch={~p"/categories/#{@category_id}/new-expense"}>
      <h3 class="text-right mr-8 mt-5">+ Add New Expense</h3>
    </.link>
    <h1 class="text-center capitalize mt-2">{@category.name}</h1>
    <div class="w-100 h-7 mt-5 mx-10 border border-black">
      <div class="bg-blue-500 h-7" style={"width:  #{@spendings_percentage}%"}>
        <span class="p-2">{@spendings_percentage}%</span>
      </div>
    </div>
    <div class="flex justify-between mt-5 mx-10">
      <div>
        <h2>Monthly budget</h2>
        <span>{@category.monthly_budget}</span>
      </div>
      <div>
        <h2>Total spendings</h2>
        <span>{@category.total_spendings}</span>
      </div>
    </div>

    <div class="mx-10">
      <h3 class="mt-5 mb-3 text-center  underline underline-offset-4">Recent expense</h3>
      <div :if={@recent_expense}>
        <div>
          <span>Description: {@recent_expense.description}</span>
        </div>
        <div>
          <span>Amount: {@recent_expense.amount}</span>
        </div>
        <div>
          <span>Date: {@recent_expense.date}</span>
        </div>
      </div>
    </div>

    <.modal
      :if={@live_action == :new_expense}
      id="new-expense"
      show
      on_cancel={JS.patch(~p"/categories/#{@category_id}")}
    >
      <h4>Add New Expense</h4>

      <.form for={@form} phx-submit="save">
        <.input field={@form[:description]} placeholder="Description" type="textarea" />
        <.input field={@form[:amount]} placeholder="Amount" />
        <.input field={@form[:notes]} placeholder="Notes (optional)" />
        <.button class="mt-2">
          Save
        </.button>
      </.form>
    </.modal>
    """
  end

  def handle_event("save", %{"expense" => params}, socket) do
    case Expenses.add_expense_to_category(
           Map.put(params, "category_id", socket.assigns.category_id)
         ) do
      {:ok, [expense, category]} ->
        {:noreply,
         socket
         |> push_patch(to: ~p"/categories/#{socket.assigns.category_id}")
         |> assign(%{
           recent_expense: expense,
           category: category,
           spendings_percentage: get_percentage(category)
         })}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}

      changeset ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  defp get_percentage(category) do
    Decimal.div(category.total_spendings, category.monthly_budget)
    |> Decimal.mult(100)
    |> Decimal.round(0)
    |> Decimal.to_integer()
  end
end
