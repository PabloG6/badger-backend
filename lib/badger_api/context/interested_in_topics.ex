defmodule BadgerApi.Context.InterestedinTopics do
  use Ecto.Schema
  import Ecto.Changeset
  alias BadgerApi.Accounts.Writer
  alias BadgerApi.Badge.Topics

  schema "interested_in_topics" do
    belongs_to :writer, Writer, type: :binary_id
    belongs_to :topics, Topics, type: :binary_id
  end

  @doc false
  def changeset(interested_in_topics, attrs) do
    interested_in_topics
    |> cast(attrs, [:writer_id, :topics_id])
    |> validate_required([:writer_id, :topics_id])
  end
end
