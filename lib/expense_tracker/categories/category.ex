defmodule ExpenseTracker.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string
    field :description, :string
    field :monthly_budget, :decimal
    field :total_spendings, :decimal, default: Decimal.new("0")

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description, :monthly_budget, :total_spendings])
    |> validate_required([:name, :description, :monthly_budget, :total_spendings])
    |> validate_total_spendings_not_exceed_budget()
  end

  defp validate_total_spendings_not_exceed_budget(changeset) do
    total_spendings = get_field(changeset, :total_spendings)
    monthly_budget = get_field(changeset, :monthly_budget)

    case Decimal.compare(total_spendings, monthly_budget) do
      :gt ->
        add_error(changeset, :total_spendings, "total spendings cannot exceed monthly budget")

      _ ->
        changeset
    end
  end
end
