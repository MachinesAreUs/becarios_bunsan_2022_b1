defmodule InvoiceValidator do

  def validate_dates(%DateTime{} = emisor_dt, %DateTime{} = pac_dt) do
    case DateTime.compare(emisor_dt, pac_dt) do
      :eq -> :ok
      _ -> :error
    end
  end
end
