defmodule InvoiceValidatorTest do
  use ExUnit.Case
  import InvoiceValidator

  Calendar.put_time_zone_database(Tzdata.TimeZoneDatabase)

  @tz_cdmx "Mexico/General"
  @tz_northwest "America/Tijuana"
  @tz_souteast "America/Cancun"
  @tz_pacific "America/Mazatlan"

  test "Emisor DateTimes equal to PAC dates are valid" do
    emisor_dt = DateTime.from_naive!(~N[2022-03-24 10:00:00], @tz_cdmx)
    pac_dt = DateTime.from_naive!(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = DateTime.from_naive!(~N[2022-03-24 09:00:00], @tz_pacific)
    pac_dt = DateTime.from_naive!(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = DateTime.from_naive!(~N[2022-03-24 09:00:00], @tz_northwest)
    pac_dt = DateTime.from_naive!(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = DateTime.from_naive!(~N[2022-03-24 11:00:00], @tz_southeast)
    pac_dt = DateTime.from_naive!(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok
  end
end
