defmodule InvoiceValidator do
  @secs_in_min 60
  @secs_in_hour 60 * @secs_in_min

  def validate_dates(%DateTime{} = emisor_dt, %DateTime{} = pac_dt) do
    {interval, lower_bound, upper_bound} = valid_interval(pac_dt)

    if emisor_dt in interval,
      do: :ok,
      else: specify_error(emisor_dt, lower_bound, upper_bound)
  end

  defp specify_error(emisor_dt, lower_bound, upper_bound) do
    cond do
      DateTime.compare(emisor_dt, lower_bound) == :lt -> {:error, :before_72_hrs}
      DateTime.compare(emisor_dt, upper_bound) == :gt -> {:error, :after_5_min}
    end
  end

  defp valid_interval(pac_dt) do
    lower_bound = DateTime.add(pac_dt, -72 * @secs_in_hour, :second)
    upper_bound = DateTime.add(pac_dt, 5 * @secs_in_min, :second)

    interval =
      Timex.Interval.new(
        from: lower_bound, until: upper_bound, left_open: false, right_open: false)

    {interval, lower_bound, upper_bound}
  end
end
