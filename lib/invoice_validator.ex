defmodule InvoiceValidator do
  @secs_in_hour 60 * 60
  @secs_in_min 60

  def validate_dates(%DateTime{} = emisor_dt, %DateTime{} = pac_dt) do
    lower_bound = DateTime.add(pac_dt, -72 * @secs_in_hour, :second)
    upper_bound = DateTime.add(pac_dt, 5 * @secs_in_min, :second)

    interval =
      Timex.Interval.new(
        from: lower_bound, until: upper_bound, left_open: false, right_open: false)

    if emisor_dt in interval do
      :ok
    else
      cond do
        DateTime.compare(emisor_dt, lower_bound) == :lt -> {:error, :before_72_hrs}
        DateTime.compare(emisor_dt, upper_bound) == :gt -> {:error, :after_5_min}
      end
    end
  end
end
