defmodule BadgerApi.Publications do
  @moduledoc """
  The Publications context.
  """

  import Ecto.Query, warn: false
  alias BadgerApi.Repo
  alias BadgerApi.Publications.Articles
  alias BadgerApi.Accounts.Relationships

  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Articles{}, ...]

  """
  def list_articles do
    Repo.all(Articles) |> Repo.preload([:categories, :writer])
  end

  @doc """
  Gets a single articles.

  Raises `Ecto.NoResultsError` if the Articles does not exist.

  ## Examples

      iex> get_articles!(123)
      %Articles{}

      iex> get_articles!(456)
      ** (Ecto.NoResultsError)

  """
  def get_articles!(id), do: Repo.get!(Articles, id) |> Repo.preload(:categories)

  @doc """
  Creates a articles.

  ## Examples

      iex> create_articles(%{field: value})
      {:ok, %Articles{}}

      iex> create_articles(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """


  def create_articles(attrs \\ %{}) do
    %Articles{}
    |> Articles.changeset(attrs)
    |> Repo.insert


  end


  @doc """
  Updates a articles.

  ## Examples

      iex> update_articles(articles, %{field: new_value})
      {:ok, %Articles{}}

      iex> update_articles(articles, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_articles(%Articles{} = articles, attrs) do

    articles
    |> Articles.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Articles.

  ## Examples

      iex> delete_articles(articles)
      {:ok, %Articles{}}

      iex> delete_articles(articles)
      {:error, %Ecto.Changeset{}}

  """
  def delete_articles(%Articles{} = articles) do
    Repo.delete(articles)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking articles changes.

  ## Examples

      iex> change_articles(articles)
      %Ecto.Changeset{source: %Articles{}}

  """
  def change_articles(%Articles{} = articles) do
    Articles.changeset(articles, %{})
  end

  #  @doc """
  # Returns an `%Articles{}` for seeing list of articles.
  # iex> get_feed()
  # %Articles{}
  # """
  # def get_feed(writer_id) do
  #   query = from articles in Articles,
  #           join: r in Relationships, on: r.follower_id == ^writer_id,
  #           join: t in topics



  # end

end
