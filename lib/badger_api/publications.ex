defmodule BadgerApi.Publications do
  @moduledoc """
  The Publications context.
  """

  import Ecto.Query, warn: false
  alias BadgerApi.Repo
  alias BadgerApi.Publications.Stories

  @doc """
  Returns the list of stories.

  ## Examples

      iex> list_stories()
      [%Stories{}, ...]

  """
  def list_stories do
    Repo.all(Stories)
  end

  @doc """
  Gets a single stories.

  Raises `Ecto.NoResultsError` if the Stories does not exist.

  ## Examples

      iex> get_stories!(123)
      %Stories{}

      iex> get_stories!(456)
      ** (Ecto.NoResultsError)

  """
  def get_stories!(id), do: Repo.get!(Stories, id)

  @doc """
  Creates a stories.

  ## Examples

      iex> create_stories(%{field: value})
      {:ok, %Stories{}}

      iex> create_stories(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_stories(attrs \\ %{}) do
    %Stories{}
    |> Stories.changeset(attrs)
    |> Repo.insert


  end
  @doc """
  Updates a stories.

  ## Examples

      iex> update_stories(stories, %{field: new_value})
      {:ok, %Stories{}}

      iex> update_stories(stories, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_stories(%Stories{} = stories, attrs) do
    stories
    |> Stories.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Stories.

  ## Examples

      iex> delete_stories(stories)
      {:ok, %Stories{}}

      iex> delete_stories(stories)
      {:error, %Ecto.Changeset{}}

  """
  def delete_stories(%Stories{} = stories) do
    Repo.delete(stories)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking stories changes.

  ## Examples

      iex> change_stories(stories)
      %Ecto.Changeset{source: %Stories{}}

  """
  def change_stories(%Stories{} = stories) do
    Stories.changeset(stories, %{})
  end
end
