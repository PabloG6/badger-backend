defmodule BadgerApi.Badge.Topics do
  use Ecto.Schema
  import Ecto.Changeset
  alias BadgerApi.Publications.Stories
  alias BadgerApi.Accounts.Writer
  alias BadgerApi.Badge.TopicsSlug
  @primary_key {:id, :binary_id, autogenerate: true}

  @derive {Phoenix.Param, key: :slug}


  schema "topics" do
    field :description, :string
    field :title, :string
    field :slug, TopicsSlug.Type
    many_to_many :stories, Stories, join_through: "categories_stories"
    many_to_many :writers, Writer, join_through: "writers_topics", on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(topics, attrs) do
    topics
    |> cast(attrs, [:title, :description])
    |> validate_required([:title])
    |> unique_constraint(:title)
    |> TopicsSlug.maybe_generate_slug
    |> TopicsSlug.unique_constraint

  end










end
