defmodule BadgerApi.Badge.TopicsSlug do
  use EctoAutoslugField.Slug, to: :slug

  def get_sources(_changeset, _opts) do
    [:title]
  end
end
