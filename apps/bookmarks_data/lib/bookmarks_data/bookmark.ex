defmodule BookmarksData.Bookmark do
  use Ecto.Schema
  import Ecto.Changeset
  alias BookmarksData.Repo

  @http_lib Application.get_env(:bookmarks_data, :http_lib)

  schema "bookmarks" do
    field :title
    field :uri
    field :description
    field :tags, BookmarksData.SortedSetType
    field :data

    timestamps()
  end

  @required_fields ~w(uri title)a
  @optional_fields ~w(title description tags)a
  @all_fields @required_fields ++ @optional_fields

  def changeset(params) do
    changeset(%BookmarksData.Bookmark{}, params)
  end
  def changeset(record, params) do
    record
    |> cast(params, @all_fields)
    |> unsafe_validate_unique(:uri, Repo)
    |> unique_constraint(:uri)
    |> BookmarksData.URIValidator.validate(:uri)
    |> fetch_data
    |> fetch_title
    |> validate_required(@required_fields)
  end

  defp fetch_data(changeset) do
    if valid_uri?(changeset) && get_field(changeset, :data) == nil do
      {:ok, data} = @http_lib.get(get_field(changeset, :uri))

      put_change(changeset, :data, data)
    else
      changeset
    end
  end

  defp fetch_title(changeset) do
    title = get_field(changeset, :title) ||
      BookmarksData.TitleExtractor.extract(get_field(changeset, :data))

    changeset
    |> put_change(:title, title)
  end

  defp valid_uri?(changeset) do
    !(:uri in (changeset.errors |> Enum.into(%{}) |> Map.keys))
  end
end
