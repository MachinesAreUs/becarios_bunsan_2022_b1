defmodule InvoiceValidator2Test do
  use ExUnit.Case, async: false
  import InvoiceValidator

  Calendar.put_time_zone_database(Tzdata.TimeZoneDatabase)

  @tz_cdmx "Mexico/General"

  @pac_dt DateTime.from_naive!(~N[2022-03-24 10:00:00], @tz_cdmx)

  test "72 hrs before, emisor in America/Tijuana at 2022-03-20 10:00:00 should fail" do
    emisor_dt = datetime(~N[2022-03-20 10:00:00], "America/Tijuana")
    assert validate_dates(emisor_dt, @pac_dt) == {:error, :before_72_hrs}
  end

  defp datetime(%NaiveDateTime{} = ndt, tz) do
    DateTime.from_naive!(ndt, tz)
  end
end
