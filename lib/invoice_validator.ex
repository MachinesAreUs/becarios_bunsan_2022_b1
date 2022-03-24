defmodule InvoiceValidator do
  @secs_in_min 60
  @secs_in_hour 60 * @secs_in_min

  def validate_dates(%DateTime{} = emisor_dt, %DateTime{} = pac_dt) do
    {interval, lower_bound, upper_bound} = valid_interval(pac_dt)

    if emisor_dt in interval do
      :ok
    else
      cond do
        lesser_than(emisor_dt, lower_bound) -> {:error, :before_72_hrs}
        greater_than(emisor_dt, upper_bound) -> {:error, :after_5_min}
      end
    end
  end

  defp lesser_than(emisor_dt, lower_bound) do
    DateTime.compare(emisor_dt, lower_bound) == :lt
  end

  defp greater_than(emisor_dt, upper_bound) do
    DateTime.compare(emisor_dt, upper_bound) == :gt
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
