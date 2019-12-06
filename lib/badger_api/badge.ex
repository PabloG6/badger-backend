defmodule BadgerApi.Badge do
  @moduledoc """
  The Badge context.
  """

  import Ecto.Query, warn: false
  alias BadgerApi.Repo
  alias BadgerApi.Publications.Articles
  alias BadgerApi.Badge.Topics
  alias BadgerApi.Context.CategoriesArticles
  alias Exsolr

  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics()
      [%Topics{}, ...]

  """
  def list_topics(params \\ %{}) do
    from(t in Topics) |> Repo.paginate(params)
  end

  def index_by_popularity(params \\ %{}) do
    from(t in Topics,
      left_join: c in CategoriesArticles,
      on: c.categories_id == t.id,
      group_by: t.id,
      order_by: [desc: count(c.id)]
    )
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single topics.

  Raises `Ecto.NoResultsError` if the Topics does not exist.

  ## Examples

      iex> get_topics!(123)
      %Topics{}

      iex> get_topics!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topics!(id), do: Repo.get!(Topics, id)

  def get_topics_by_slug!(slug), do: Repo.get_by!(Topics, slug: slug)
  def get_topics_by_slug(slug), do: Repo.get_by(Topics, slug: slug)

  def filter_articles!(slug, params \\ %{}) do
    query =
      from articles in Articles,
        left_join: category in assoc(articles, :categories),
        where: category.slug == ^slug,
        preload: [:categories, :writer]

    Repo.paginate(query, params)
  end

  @doc """
  Creates a topics.

  ## Examples

      iex> create_topics(%{field: value})
      {:ok, %Topics{}}

      iex> create_topics(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topics(attrs \\ %{}) do
    # case Topics.changeset(%Topics{}, attrs) |> Repo.insert() do
    #   {:ok, topic} = response ->
    #     Exsolr.add(%{title: topic.title, slug: topic.slug, description: topic.description})
    #     response

    #   {:error, _} = error ->
    #     error
    # end

    Topics.changeset(%Topics{}, attrs) |> Repo.insert()
  end

  @doc """
  Updates a topics.

  ## Examples

      iex> update_topics(topics, %{field: new_value})
      {:ok, %Topics{}}

      iex> update_topics(topics, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_topics(%Topics{} = topics, attrs) do
    topics
    |> Topics.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Topics.

  ## Examples

      iex> delete_topics(topics)
      {:ok, %Topics{}}

      iex> delete_topics(topics)
      {:error, %Ecto.Changeset{}}

  """
  def delete_topics(%Topics{} = topics) do
    case Repo.delete(topics) do
      {:ok, topic} = response ->
        # Exsolr.delete_by_id(topic.id)
        response

      error ->
        error
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking topics changes.

  ## Examples

      iex> change_topics(topics)
      %Ecto.Changeset{source: %Topics{}}

  """
  def change_topics(%Topics{} = topics) do
    Topics.changeset(topics, %{})
  end
end
