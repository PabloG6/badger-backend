defmodule BadgerApi.Context.WritesAboutTopics do
  use Ecto.Schema
  import Ecto.Changeset
  alias BadgerApi.Accounts.Writer
  alias BadgerApi.Badge.Topics
  schema "writes_about_topics" do
    belongs_to :writer, Writer, type: :binary_id
    belongs_to :topics, Topics, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(writes_about_topics, attrs) do
    writes_about_topics
    |> cast(attrs, [:writer_id, :topics_id])
    |> validate_required([:writer_id, :topics_id])
  end
end
