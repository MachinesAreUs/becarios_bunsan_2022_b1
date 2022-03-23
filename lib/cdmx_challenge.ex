defmodule CDMXChallenge do

  defmodule Line do
    #defstruct name: "", stations: []
    defstruct [:name, :stations]
  end

  defmodule Station do
    defstruct [:name, :coords]
  end

  @doc """
  Obtains ....

  ## Examples
    iex> CDMXChallenge.metro_lines("./data/tiny_metro.kml")
    [
      %Line{name: "Línea 5", stations:
        [
          %Station{name: "Pantitlan", coords: "90.0123113 30.012121"},
          %Station{name: "Hangares", coords: "90.0123463 30.012158"}
        ]
      },
      %Line{name: "Línea 1", stations:
        [
          %Station{name: "Universidad", coords: "90.0123113 30.012121"},
          %Station{name: "Copilco", coords: "90.0123463 30.012158"}
        ]
      }
    ]
  """
  def metro_lines(xml_path) do

  end

  def metro_graph(xml_path) do
    lines = metro_lines(xml_path)
    # Create graph ...
  end
end
