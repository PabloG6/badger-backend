defmodule BadgerApi.Accounts.Writer do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias BadgerApi.Publications.Stories
  alias BadgerApi.Badge.Topics
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
    many_to_many :writes_about_topics, Topics, join_through: "writers_topics", on_delete: :delete_all
    many_to_many :interested_in_topics, Topics, join_through: "topics_interests", on_delete: :delete_all
    has_many :interests, through: [:interested_in_topics, :topics]
    has_many :active_relationships, Relationships, foreign_key: :following_id
    has_many :passive_relationships, Relationships, foreign_key: :follower_id
    has_many :followers, through: [:active_relationships, :follower]
    has_many :following, through: [:passive_relationships, :following]
    timestamps()
  end





  @doc false
  def changeset(writer, attrs) do
    writer
    |> cast(attrs, [:name, :username, :email, :description, :password, ])
    |> validate_required([:name, :username, :email, :password])
    |> put_assoc(:writes_about_topics, parse_interests(attrs))
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_format(:username, ~r/(\@[a-zA-Z0-9_%]*)/)
    |> downcase_username
    |> downcase_email
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp parse_interests(attrs) do
    (attrs["writes_about_topics"] || attrs[:writes_about_topics] || []) |> upsert_interests_list
  end


  defp upsert_interests_list([]) do
    []
  end

  defp upsert_interests_list(interests) do

     interests_map = Enum.map(interests, &%{title: &1, slug: Slug.slugify(&1),
     updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second),
     inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second)})
    Repo.insert_all Topics, interests_map, on_conflict: :nothing
    Repo.all from topic in Topics, where: topic.title in ^interests
  end

  defp downcase_username(%Ecto.Changeset{valid?: true, changes: %{email: email}} = changeset) do
    change(changeset, %{email: String.downcase(email)})
  end
  defp downcase_username(changeset), do: changeset

  defp downcase_email(%Ecto.Changeset{valid?: true, changes: %{username: username}} = changeset) do
    change(changeset, %{username: String.downcase(username)})
  end
  defp downcase_email(changeset), do: changeset

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, %{password_hash: Bcrypt.hash_pwd_salt(password)})

  end
  defp hash_password(changeset), do: changeset

end
