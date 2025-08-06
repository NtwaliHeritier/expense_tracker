defmodule ExpenseTrackerWeb.CategoryLive do
  use ExpenseTrackerWeb, :live_view

  alias ExpenseTracker.Categories
  alias ExpenseTracker.Expenses

  def mount(%{"category_id" => category_id}, _session, socket) do
    category = Categories.get_category(category_id)

    spendings_percentage =
      Decimal.div(category.total_spendings, category.monthly_budget)
      |> Decimal.mult(100)
      |> Decimal.round(0)
      |> Decimal.to_integer()

    recent_expense = Expenses.get_recent_category_expense(category_id)

    {:ok,
     socket
     |> assign(%{
       category: category,
       spendings_percentage: spendings_percentage,
       recent_expense: recent_expense
     })}
  end

  def render(assigns) do
    ~H"""
    <.link navigate={~p"/categories"}>
      <h1 class="mt-5 pl-8 underline underline-offset-4">All Categories</h1>
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
      <h3 class="mt-5 mb-3">Recent expense</h3>
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
    """
  end
end
