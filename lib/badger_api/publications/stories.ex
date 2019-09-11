defmodule BadgerApi.Publications.Stories do
  use Ecto.Schema
  import Ecto.Changeset
  alias BadgerApi.Accounts.Writer
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "stories" do
    field :body, :string
    field :description, :string
    field :title, :string
    belongs_to :writer, Writer, type: :binary_id
    timestamps()
  end

  @doc false
  def changeset(stories, attrs) do

    stories
    |> cast(attrs, [:title, :body, :description, :writer_id])
    |> foreign_key_constraint(:writer_id)
    |> validate_required([:title, :body, :description, :writer_id])
  end
end
