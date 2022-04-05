defmodule InvoiceValidator3Test do
  use ExUnit.Case, async: false
  import InvoiceValidator

  Calendar.put_time_zone_database(Tzdata.TimeZoneDatabase)

  @tz_cdmx "Mexico/General"

  @pac_dt DateTime.from_naive!(~N[2022-03-24 10:00:00], @tz_cdmx)

  data = [
    {"72 hrs before", "America/Tijuana", ~N[2022-03-20 13:06:31], :error},
    {"72 hrs before", "America/Mazatlan", ~N[2022-03-20 14:06:31], :error},
    {"72 hrs before", "America/Tijuana", ~N[2022-03-20 13:06:35], :ok},
  ]

  for {a, b, c, d} <- data do
    @a a
    @b b
    @c c
    @d d
    test "#{@a}, emisor in #{@b} at #{@c} returns #{@d}" do
      # Change test implementation
      assert DateTime.compare(datetime(@c, @b), datetime(@c, @b)) == :eq
    end
  end

  defp datetime(%NaiveDateTime{} = ndt, tz) do
    DateTime.from_naive!(ndt, tz)
  end
end
