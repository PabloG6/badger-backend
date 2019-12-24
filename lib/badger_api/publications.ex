defmodule BadgerApi.Publications do
  @moduledoc """
  The Publications context.
  """

  import Ecto.Query, warn: false
  alias BadgerApi.Repo
  alias BadgerApi.Publications.Articles
  alias BadgerApi.Accounts.{Relationships, Writer}

  alias BadgerApi.Context.InterestedinTopics
  alias BadgerApi.Context.CategoriesArticles
  alias Exsolr

  @doc """
  Returns the list of articles.

  ## Examples

      iex> list_articles()
      [%Articles{}, ...]

  """
  def list_articles(params \\ %{}) do
    from(p in Articles, preload: [:categories, :writer])
    |> Repo.paginate(params)
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
    # writer = &%{name: &1.name, username: &1.username, email: &1.email, avatar: &1.avatar}

    # categories = fn categories ->
    #   Enum.map(categories, &%{title: &1.title, description: &1.description, slug: &1.slug})
    # end

    # case %Articles{}
    #      |> Articles.changeset(attrs)
    #      |> Repo.insert() do
    #   {:ok, articles} = response ->
    #     articles = articles |> Repo.preload([:writer, :categories])
    #   article = %{
    #       id: articles.id,
    #       title: articles.title,
    #       content: articles.content,
    #       description: articles.description,
    #       _childDocuments_: [
    #          writer.(articles.writer),
    #         categories.(articles.categories)
    #       ]
    #     }

    #     article |> Exsolr.add
    #     response

    #   error ->
    #     error
    # end

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
  def list_feed_articles(writer_id, params \\ %{}) do


    query =
      from(articles in Articles,
        preload: [:categories, :writer],
        join: t in InterestedinTopics,
        on: t.writer_id == ^writer_id,
        join: ac in CategoriesArticles,
        on:  t.topics_id == ac.categories_id,
        on: articles.id == ac.articles_id,
        join: r in Relationships,
        on: r.follower_id == ^writer_id,
        where: articles.writer_id == r.following_id,
        or_where: articles.writer_id == t.writer_id,
        or_where: articles.id == ac.articles_id,
        order_by: [desc: articles.inserted_at],
        select: [:id, :title, :description, :cover_photo, :writer_id, categories: [:id, :slug, :title],  writer: [:id, :username, :name, :avatar]],
        distinct: [articles.id]
        )

      {string_query, _data} = Ecto.Adapters.SQL.to_sql(:all, Repo, query)
      IO.puts string_query
      IO.puts writer_id


    Repo.paginate(query, params)
  end
end
