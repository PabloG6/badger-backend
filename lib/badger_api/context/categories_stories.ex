defmodule BadgerApi.Context.CategoriesArticles do
  use Ecto.Schema
  import Ecto.Changeset
  alias BadgerApi.Badge.Topics
  alias BadgerApi.Publications.Articles

  schema "categories_articles" do
    belongs_to :categories, Topics, type: :binary_id
    belongs_to :articles, Articles, type: :binary_id
  end

  @doc false
  def changeset(categories_articles, attrs) do
    categories_articles
    |> cast(attrs, [:categories_id, :articles_id])
    |> validate_required([:categories_id, :articles_id])
    |> unique_constraint([:categories_id, :articles_id])
  end
end
