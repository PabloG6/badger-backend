defmodule BadgerApi.Context.TopicsInterest do
  use Ecto.Schema
  import Ecto.Changeset
  alias BadgerApi.Accounts.Writer
  alias BadgerApi.Badge.Topics
  schema "topics_interests" do
    belongs_to :writer, Writer
    belongs_to :topics, Topics

  end

  @doc false
  def changeset(topics_interest, attrs) do
    topics_interest
    |> cast(attrs, [:writer_id, :topics_id])
    |> validate_required([:writer_id, :topics_id])

  end
end
