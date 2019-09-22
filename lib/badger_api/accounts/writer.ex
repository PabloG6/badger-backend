defmodule BadgerApi.Accounts.Writer do
  use Ecto.Schema
  import Ecto.Changeset
  alias BadgerApi.Publications.Stories
  alias BadgerApi.Badge.Topics
  alias BadgerApi.Badge
  alias BadgerApi.Accounts.Relationships
  alias BadgerApi.Repo
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "writers" do
    field :description, :string
    field :email, :string
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :stories, Stories
    many_to_many :interests, Topics, join_through: "writers_topics", on_delete: :delete_all
    has_many :active_relationships, Relationships, foreign_key: :following_id
    has_many :passive_relationships, Relationships, foreign_key: :follower_id
    has_many :followers, through: [:active_relationships, :follower]
    has_many :following, through: [:passive_relationships, :following]
    timestamps()
  end


  def changeset(writer, %{interests: interests} = attrs)  do


    writer
    |> cast(attrs, [:name, :username, :email, :description, :password, ])
    |> put_assoc(:interests, upsert_interests_list(interests))
    |> validate_required([:name, :username, :email, :password])
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_format(:username, ~r/(\@[a-zA-Z0-9_%]*)/)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> hash_password()

  end


  @doc false
  def changeset(writer, attrs) do
    writer
    |> cast(attrs, [:name, :username, :email, :description, :password, ])
    |> validate_required([:name, :username, :email, :password])
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_format(:username, ~r/(\@[a-zA-Z0-9_%]*)/)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> hash_password()
  end


  def upsert_interests_list(interests) do
     for interest <- interests, do: %Topics{}
     |> Topics.changeset(interest)
     |> unsafe_validate_unique([:title, :slug], Repo)
     |> mark_maybe_for_creation
  end

  def mark_maybe_for_creation(%Ecto.Changeset{valid?: false, changes: %{slug: slug}}), do: Badge.get_topics_by_slug(slug)
  def mark_maybe_for_creation(%Ecto.Changeset{valid?: true} = changeset), do: changeset


  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, %{password_hash: Bcrypt.hash_pwd_salt(password)})

  end
  defp hash_password(changeset), do: changeset

end
