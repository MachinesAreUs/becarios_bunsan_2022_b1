defmodule InvoiceValidator do

  @secs_in_hour 60 * 60

  def validate_dates(%DateTime{} = emisor_dt, %DateTime{} = pac_dt) do
    case DateTime.compare(emisor_dt, pac_dt) do
      :eq -> :ok
      :lt ->
        upper_bound_emisor_dt = DateTime.add(emisor_dt, 72 * @secs_in_hour, :second)
        case DateTime.compare(upper_bound_emisor_dt, pac_dt) do
          :eq -> :ok
          :gt -> :ok
          :lt -> :error
        end
    end
  end
end
