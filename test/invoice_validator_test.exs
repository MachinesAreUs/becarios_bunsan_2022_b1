defmodule InvoiceValidatorTest do
  use ExUnit.Case
  import InvoiceValidator

  Calendar.put_time_zone_database(Tzdata.TimeZoneDatabase)

  @tz_cdmx "Mexico/General"
  @tz_northwest "America/Tijuana"
  @tz_southeast "America/Cancun"
  @tz_pacific "America/Mazatlan"

  test "Emisor datetimes equal to PAC datetimes are valid" do
    emisor_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-24 09:00:00], @tz_pacific)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-24 09:00:00], @tz_northwest)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-24 11:00:00], @tz_southeast)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok
  end

  test "Emisor datetimes exactly 72 hrs before PAC datetimes are valid" do
    emisor_dt = datetime(~N[2022-03-21 10:00:00], @tz_cdmx)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-21 09:00:00], @tz_pacific)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-21 09:00:00], @tz_northwest)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-21 11:00:00], @tz_southeast)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok
  end

  test "Emisor datetimes less than 72 hrs before PAC datetimes are valid" do
    emisor_dt = datetime(~N[2022-03-21 10:00:01], @tz_cdmx)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-21 09:00:01], @tz_pacific)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-21 09:00:01], @tz_northwest)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-21 11:00:01], @tz_southeast)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok
  end

  test "Emisor datetimes exactly 5 min after PAC datetimes are valid" do
    emisor_dt = datetime(~N[2022-03-24 10:05:00], @tz_cdmx)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-24 09:05:00], @tz_pacific)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-24 09:05:00], @tz_northwest)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-24 11:05:00], @tz_southeast)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok
  end

  test "Emisor datetimes less than 5 min after PAC datetimes are valid" do
    emisor_dt = datetime(~N[2022-03-24 10:00:01], @tz_cdmx)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-24 09:00:01], @tz_pacific)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-24 09:00:01], @tz_northwest)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok

    emisor_dt = datetime(~N[2022-03-24 11:00:01], @tz_southeast)
    pac_dt = datetime(~N[2022-03-24 10:00:00], @tz_cdmx)
    assert validate_dates(emisor_dt, pac_dt) == :ok
  end

  defp datetime(%NaiveDateTime{} = ndt, tz) do
    DateTime.from_naive!(ndt, tz)
  end
end
