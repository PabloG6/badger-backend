defmodule BadgerApi.Badge.Topics do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "topics" do
    field :description, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(topics, attrs) do
    topics
    |> cast(attrs, [:title, :description])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
