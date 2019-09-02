defmodule BadgerApi.Accounts.Writer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "writers" do
    field :description, :string
    field :email, :string
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(writer, attrs) do
    writer
    |> cast(attrs, [:name, :username, :email, :description, :password])
    |> validate_required([:name, :username, :email, :password])
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_format(:username, ~r/(\@[a-zA-Z0-9_%]*)/)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |>hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, %{password_hash: Bcrypt.hash_pwd_salt(password)})

  end
  defp hash_password(changeset), do: changeset

end
