defmodule ExpenseTrackerWeb.CategoriesLiveTest do
  use ExpenseTrackerWeb.ConnCase
  import Phoenix.LiveViewTest

  alias ExpenseTracker.Categories

  @valid_attrs %{
    name: "Groceries",
    description: "Monthly groceries",
    monthly_budget: Decimal.new("300")
  }
  @invalid_attrs %{name: "", description: "", monthly_budget: nil}

  setup do
    category = Categories.create_category(@valid_attrs)
    %{category: category}
  end

  test "displays list of categories", %{conn: conn} do
    {:ok, _view, html} = live(conn, ~p"/categories")

    assert html =~ "Categories list"
    assert html =~ "Groceries"
  end

  test "opens modal form on + Add New Category click", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/categories")

    assert view |> element("a", "+ Add New Category") |> render_click() =~ "Add New Category"
  end

  test "successfully submits form", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/categories/new")

    form_data = %{
      category: %{
        name: "Utilities",
        description: "Electricity and water",
        monthly_budget: 200
      }
    }

    view
    |> form("form", form_data)
    |> render_submit()

    assert_patch(view, ~p"/categories")
    assert has_element?(view, "h3", "Utilities")
  end

  test "shows errors when form submission is invalid", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/categories/new")

    view
    |> form("form", %{category: @invalid_attrs})
    |> render_submit()

    assert render(view) =~ "can&#39;t be blank"
  end

  test "streams new category on pubsub broadcast", %{conn: conn} do
    {:ok, view, _html} = live(conn, ~p"/categories")

    {:ok, new_category} =
      Categories.create_category(%{
        name: "Travel",
        description: "Vacations and trips",
        monthly_budget: 500
      })

    send(view.pid, {:category_created, new_category})

    assert has_element?(view, "h3", "Travel")
  end
end
