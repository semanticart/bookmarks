defmodule BookmarksData.URIValidator do
  import Ecto.Changeset

  def validate(changeset, field) do
    validate(changeset, field, changeset.changes[field])
  end

  def validate(changeset, _field, nil), do: changeset
  def validate(changeset, field, uri) do
    if valid?(uri) do
      changeset
    else
      add_error(changeset, field, "is invalid", uri: URI.parse(uri))
    end
  end

  def valid?(uri) do
    uri = URI.parse(uri)

    uri.scheme != nil && uri.host =~ "."
  end
end
