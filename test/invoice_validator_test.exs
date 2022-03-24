defmodule InvoiceValidatorTest do
  use ExUnit.Case
  import InvoiceValidator

  Calendar.put_time_zone_database(Tzdata.TimeZoneDatabase)

  @tz_cdmx "Mexico/General"
  @tz_northwest "America/Tijuana"
  @tz_southeast "America/Cancun"
  @tz_pacific "America/Mazatlan"
  @pac_dt DateTime.from_naive!(~N[2022-03-24 10:00:00], @tz_cdmx)

  test "Emisor datetimes equal to PAC datetimes are valid" do
    examples = [
      datetime(~N[2022-03-24 10:00:00], @tz_cdmx),
      datetime(~N[2022-03-24 09:00:00], @tz_pacific),
      datetime(~N[2022-03-24 09:00:00], @tz_northwest),
      datetime(~N[2022-03-24 11:00:00], @tz_southeast)
    ]

    Enum.each(examples, fn dt ->
      assert validate_dates(dt, @pac_dt) == :ok
    end)
  end

  test "Emisor datetimes exactly 72 hrs before PAC datetimes are valid" do
    examples = [
      datetime(~N[2022-03-21 10:00:00], @tz_cdmx),
      datetime(~N[2022-03-21 09:00:00], @tz_pacific),
      datetime(~N[2022-03-21 09:00:00], @tz_northwest),
      datetime(~N[2022-03-21 11:00:00], @tz_southeast)
    ]

    Enum.each(examples, fn dt ->
      assert validate_dates(dt, @pac_dt) == :ok
    end)
  end

  test "Emisor datetimes less than 72 hrs before PAC datetimes are valid" do
    examples = [
      datetime(~N[2022-03-21 10:00:01], @tz_cdmx),
      datetime(~N[2022-03-21 09:00:01], @tz_pacific),
      datetime(~N[2022-03-21 09:00:01], @tz_northwest),
      datetime(~N[2022-03-21 11:00:01], @tz_southeast)
    ]

    Enum.each(examples, fn dt ->
      assert validate_dates(dt, @pac_dt) == :ok
    end)
  end

  test "Emisor datetimes exceeding 72 hrs before PAC datetimes are invalid" do
    examples = [
      datetime(~N[2022-03-21 09:59:59], @tz_cdmx),
      datetime(~N[2022-03-21 08:59:59], @tz_pacific),
      datetime(~N[2022-03-21 08:59:59], @tz_northwest),
      datetime(~N[2022-03-21 10:59:59], @tz_southeast)
    ]

    Enum.each(examples, fn dt ->
      assert validate_dates(dt, @pac_dt) == {:error, :before_72_hrs}
    end)
  end

  test "Emisor datetimes exactly 5 min after PAC datetimes are valid" do
    examples = [
      datetime(~N[2022-03-24 10:05:00], @tz_cdmx),
      datetime(~N[2022-03-24 09:05:00], @tz_pacific),
      datetime(~N[2022-03-24 09:05:00], @tz_northwest),
      datetime(~N[2022-03-24 11:05:00], @tz_southeast)
    ]

    Enum.each(examples, fn dt ->
      assert validate_dates(dt, @pac_dt) == :ok
    end)
  end

  test "Emisor datetimes less than 5 min after PAC datetimes are valid" do
    examples = [
      datetime(~N[2022-03-24 10:00:01], @tz_cdmx),
      datetime(~N[2022-03-24 09:00:01], @tz_pacific),
      datetime(~N[2022-03-24 09:00:01], @tz_northwest),
      datetime(~N[2022-03-24 11:00:01], @tz_southeast)
    ]

    Enum.each(examples, fn dt ->
      assert validate_dates(dt, @pac_dt) == :ok
    end)
  end

  defp datetime(%NaiveDateTime{} = ndt, tz) do
    DateTime.from_naive!(ndt, tz)
  end
end
