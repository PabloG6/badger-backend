defmodule BadgerApi.Accounts.Relationships do
  use Ecto.Schema
  import Ecto.Changeset
  alias BadgerApi.Accounts.Writer
  schema "relationships" do
    belongs_to :follower, Writer, type: :binary_id
    belongs_to :following, Writer, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(relationships, attrs) do
    relationships
    |> cast(attrs, [:follower_id, :following_id])
    |> validate_required([:follower_id, :following_id])
    |> foreign_key_constraint(:follower_id)
    |> foreign_key_constraint(:following_id)

  end
end
