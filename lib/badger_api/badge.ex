defmodule BadgerApi.Badge do
  @moduledoc """
  The Badge context.
  """

  import Ecto.Query, warn: false
  alias BadgerApi.Repo

  alias BadgerApi.Badge.Topics

  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics()
      [%Topics{}, ...]

  """
  def list_topics do
    Repo.all(Topics)
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








  @doc """
  Creates a topics.

  ## Examples

      iex> create_topics(%{field: value})
      {:ok, %Topics{}}

      iex> create_topics(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_topics(topics \\ %{})

  def create_topics(%{"title" => nil, "description" => _description} = topics) do

    Topics.changeset(%Topics{}, topics) |> Repo.insert
  end
  def create_topics(%{title: nil, description: _description} = topics) do

    Topics.changeset(%Topics{}, topics) |> Repo.insert
  end


  def create_topics( %{"title" => title, "description" => _description} = topics) do

    changed_attrs = %{topics | "title" => title
    |> String.trim()
    |> String.replace(" ", "-")
    |> String.downcase }
    Topics.changeset(%Topics{}, changed_attrs) |> Repo.insert
  end

  def create_topics(%{title: title, description: _description} = topics) do
    changed_attrs = %{topics | title: title
    |> String.trim()
    |> String.replace(" ", "-")
    |> String.downcase}
    Topics.changeset(%Topics{}, changed_attrs) |> Repo.insert
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

  def get_topic_stories(_title) do
    Repo.all(Topics)
  end


end
