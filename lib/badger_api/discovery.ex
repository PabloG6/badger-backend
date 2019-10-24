defmodule BadgerApi.Discovery do
  @moduledoc """
  The Discovery context.
  """

  import Ecto.Query, warn: false
  alias BadgerApi.Repo

  alias BadgerApi.Discovery.Search

  @doc """
  Returns the list of search.

  ## Examples

      iex> list_search()
      [%Search{}, ...]

  """
  def list_search do
    raise "TODO"
  end

  @doc """
  Gets a single search.

  Raises if the Search does not exist.

  ## Examples

      iex> get_search!(123)
      %Search{}

  """
  def get_search!(id), do: raise "TODO"

  @doc """
  Creates a search.

  ## Examples

      iex> create_search(%{field: value})
      {:ok, %Search{}}

      iex> create_search(%{field: bad_value})
      {:error, ...}

  """
  def create_search(attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a search.

  ## Examples

      iex> update_search(search, %{field: new_value})
      {:ok, %Search{}}

      iex> update_search(search, %{field: bad_value})
      {:error, ...}

  """
  def update_search(%Search{} = search, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a Search.

  ## Examples

      iex> delete_search(search)
      {:ok, %Search{}}

      iex> delete_search(search)
      {:error, ...}

  """
  def delete_search(%Search{} = search) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking search changes.

  ## Examples

      iex> change_search(search)
      %Todo{...}

  """
  def change_search(%Search{} = search) do
    raise "TODO"
  end
end
