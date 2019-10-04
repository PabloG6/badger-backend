defmodule BadgerApi.Context.CategoriesArticles do
  use Ecto.Schema
  import Ecto.Changeset
  alias BadgerApi.Badge.Topics
  alias BadgerApi.Publications.Articles
  schema "categories_articles" do
    belongs_to :categories, Topics
    belongs_to :articles, Articles

    timestamps()
  end

  @doc false
  def changeset(categories_articles, attrs) do
    categories_articles
    |> cast(attrs, [:categories_id, :articles_id])
    |> validate_required([:categories_id, :articles_id])
  end
end
