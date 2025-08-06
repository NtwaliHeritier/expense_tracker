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
    |> validate_non_negative_monthly_budget()
  end

  defp validate_total_spendings_not_exceed_budget(changeset) do
    total_spendings = get_field(changeset, :total_spendings)
    monthly_budget = get_field(changeset, :monthly_budget)

    if total_spendings && monthly_budget do
      case Decimal.compare(total_spendings, monthly_budget) do
        :gt ->
          add_error(changeset, :total_spendings, "Total spendings cannot exceed monthly budget")

        _ ->
          changeset
      end
    else
      changeset
    end
  end

  defp validate_non_negative_monthly_budget(changeset) do
    monthly_budget = get_field(changeset, :monthly_budget)

    if monthly_budget do
      case Decimal.compare(monthly_budget, Decimal.new("0")) do
        :gt ->
          changeset

        _ ->
          add_error(changeset, :monthly_budget, "Monthly budget can't be zero or negative")
      end
    else
      changeset
    end

    # validate_change(changeset, field, fn _, value ->
    #   if Decimal.compare(value, Decimal.new(0)) == :lt &&
    #        Decimal.compare(value, Decimal.new(0)) == :eq do
    #     [{field, "must be zero or greater"}]
    #   else
    #     []
    #   end
    # end)
  end
end
