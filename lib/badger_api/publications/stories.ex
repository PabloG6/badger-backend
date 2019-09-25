defmodule BadgerApi.Publications.Stories do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias BadgerApi.Repo
  alias BadgerApi.Badge.Topics
  alias BadgerApi.Accounts.Writer
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "stories" do
    field :body, :string
    field :description, :string
    field :title, :string
    many_to_many :categories, Topics, join_through: "categories_stories", on_replace: :delete, join_keys: [stories_id: :id, categories_id: :id]

    belongs_to :writer, Writer, type: :binary_id
    timestamps()
  end

  @doc false
  def changeset(stories, attrs) do

    stories
    |> cast(attrs, [:title, :body, :description, :writer_id])
    |> put_assoc(:categories, parse_categories(attrs))
    |> foreign_key_constraint(:writer_id)
    |> validate_required([:title, :body, :description, :writer_id])
  end



  defp parse_categories(attrs) do
    (attrs["categories"] || attrs[:categories] || [])
            |> insert_and_get_all
  end

  defp insert_and_get_all([]) do
    []
  end
  defp insert_and_get_all(categories) do
    categories_map = Enum.map(categories, &%{title: &1, inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second),
    updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second), slug: Slug.slugify &1})

    Repo.insert_all Topics, categories_map, on_conflict: :nothing
    Repo.all from category in Topics, where: category.title in ^categories
  end


end


