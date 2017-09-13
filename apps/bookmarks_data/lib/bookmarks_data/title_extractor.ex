defmodule BookmarksData.TitleExtractor do
  def extract(nil), do: nil
  def extract(html) do
    html
    |> Floki.find("title")
    |> Floki.text
    |> squish
  end

  defp squish(string) do
    string
    |> String.trim
    |> String.replace(~r/\s+/, " ")
  end
end
