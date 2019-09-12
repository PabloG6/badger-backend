defmodule BadgerApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BadgerApi.Repo

  alias BadgerApi.Accounts.Writer

  @doc """
  Returns the list of writers.

  ## Examples

      iex> list_writers()
      [%Writer{}, ...]

  """
  def list_writers do
    Repo.all(Writer)
  end


  @doc """
  Gets a single writer.

  Raises `Ecto.NoResultsError` if the Writer does not exist.

  ## Examples

      iex> get_writer!(123)
      %Writer{}

      iex> get_writer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_writer!(id), do: Repo.get!(Writer, id)

  @doc """
  Creates a writer.

  ## Examples

      iex> create_writer(%{field: value})
      {:ok, %Writer{}}

      iex> create_writer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_writer(attrs \\ %{}) do
    %Writer{}
    |> Writer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a writer.

  ## Examples

      iex> update_writer(writer, %{field: new_value})
      {:ok, %Writer{}}

      iex> update_writer(writer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_writer(%Writer{} = writer, attrs) do
    writer
    |> Writer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Writer.

  ## Examples

      iex> delete_writer(writer)
      {:ok, %Writer{}}

      iex> delete_writer(writer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_writer(%Writer{} = writer) do
    Repo.delete(writer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking writer changes.

  ## Examples

      iex> change_writer(writer)
      %Ecto.Changeset{source: %Writer{}}

  """

  def authenticate_writer(%{identifier: identifier, password: password}) do
   if Regex.match?(~r/(?<=^|(?<=[^a-zA-Z0-9-_.]))@([A-Za-z]+[A-Za-z0-9-_]+)/, identifier) do
    find_by_username(identifier, password)
   else if Regex.match?(~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, identifier) do
    find_by_email(identifier, password)
   else
    {:error, "Email or username not present in database"}

   end
  end



  end

  defp find_by_username(username, password) do
    query = from(writer in Writer, where: writer.username == ^username)
    query |> Repo.one() |> verify_password(password)
  end

  defp find_by_email(email, password) do
    from(writer in Writer, where: writer.email == ^email) |> Repo.one |> verify_password(password)
  end

  defp verify_password(nil, _) do
    Bcrypt.no_user_verify()
    {:error, "Wrong username, email or password"}
  end

  defp verify_password(writer, password) do
    if Bcrypt.verify_pass(password, writer.password_hash) do
      {:ok, writer}
    else
      {:error, "Wrong username, email or password"}

    end
end

  def change_writer(%Writer{} = writer) do
    Writer.changeset(writer, %{})
  end
end
