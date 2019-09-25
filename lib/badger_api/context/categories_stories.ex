defmodule BadgerApi.Context.CategoriesStories do
  use Ecto.Schema
  import Ecto.Changeset
  alias BadgerApi.Badge.Topics
  alias BadgerApi.Publications.Stories
  schema "categories_stories" do
    belongs_to :categories, Topics
    belongs_to :stories, Stories

    timestamps()
  end

  @doc false
  def changeset(categories_stories, attrs) do
    categories_stories
    |> cast(attrs, [:categories_id, :stories_id])
    |> validate_required([:categories_id, :stories_id])
  end
end
