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
  def change_writer(%Writer{} = writer) do
    Writer.changeset(writer, %{})
  end
end
