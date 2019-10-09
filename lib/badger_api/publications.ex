defmodule BadgerApi.Publications do
  @moduledoc """
  The Publications context.
  """

  import Ecto.Query, warn: false
  alias BadgerApi.Repo
  alias BadgerApi.Publications.Articles
  alias BadgerApi.Accounts.Relationships
  alias BadgerApi.Context.InterestedinTopics
  alias BadgerApi.Context.CategoriesArticles

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
    |> Repo.insert()
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

  @doc """
  Returns an `%Articles{}` for seeing list of articles.
  iex> list_feed_articles(writer_id)
  [%Articles{}...]
  """
  def list_feed_articles(writer_id) do
    following_query =
      from relationship in Relationships,
        where: relationship.follower_id == ^writer_id

    subscribed_topics_query =
      from interested_in_topics in InterestedinTopics,
        where: interested_in_topics.writer_id == ^writer_id

    articles_topics_query =
      from article_topics in CategoriesArticles,
        join: sub_topics_query in subquery(subscribed_topics_query),
        where: sub_topics_query.topics_id == article_topics.categories_id

    query =
      from articles in Articles,
        preload: [:categories, :writer],
        join: following in subquery(following_query),
        join: a in subquery(articles_topics_query),
        on:
          a.articles_id == articles.id or following.following_id == articles.writer_id or
            articles.writer_id == ^writer_id,
        order_by: [asc: articles.inserted_at],
        distinct: [articles.id]

    Repo.all(query)
  end
end
