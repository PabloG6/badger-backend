defmodule BadgerApi.Badge do
  @moduledoc """
  The Badge context.
  """

  import Ecto.Query, warn: false
  alias BadgerApi.Repo
  alias BadgerApi.Publications.Articles
  alias BadgerApi.Badge.Topics

  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics()
      [%Topics{}, ...]

  """
  def list_topics(params \\ %{}) do
    from(t in Topics) |> Repo.paginate(params)
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
  def create_topics(topics \\ %{}) do
    Topics.changeset(%Topics{}, topics) |> Repo.insert()
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
    Repo.delete(topics)
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
