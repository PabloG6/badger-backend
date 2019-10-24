defmodule BadgerApi.Context do
  @moduledoc """
  The Context context.
  """

  import Ecto.Query, warn: false
  alias BadgerApi.Repo

  alias BadgerApi.Context.InterestedinTopics
  alias BadgerApi.Badge.Topics

  @doc """
  Returns the list of topics_interest.

  ## Examples

      iex> list_topics_interest()
      [%InterestedinTopics{}, ...]

  """

  def list_topics_interest(id, params \\ %{}) do
    query =
      from t in Topics,
        join: i in InterestedinTopics,
        on: [topics_id: t.id, writer_id: ^id]

    Repo.paginate(query, params)
  end

  @doc """
  checks if the user is following this topic
  iex> is_following?(writer_id, topics_id)
  true
  """

  def is_following?(writer_id, topics_id) do
    Repo.exists?(from InterestedinTopics, where: [writer_id: ^writer_id, topics_id: ^topics_id])
  end

  def get_specific_topics_interest!(writer_id, topics_id),
    do: Repo.get_by!(InterestedinTopics, writer_id: writer_id, topics_id: topics_id)

  def get_topics_interest!(id) do
    Repo.get!(InterestedinTopics, id)
  end

  @doc """
  Creates a topics_interest.

  ## Examples

      iex> create_topics_interest(%{field: value})
      {:ok, %InterestedinTopics{}}

      iex> create_topics_interest(%{field: bad_value})
      {:error, ...}

  """
  def create_topics_interest(attrs \\ %{}) do
    InterestedinTopics.changeset(%InterestedinTopics{}, attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a InterestedinTopics.

  ## Examples

      iex> delete_topics_interest(topics_interest)
      {:ok, %InterestedinTopics{}}

      iex> delete_topics_interest(topics_interest)
      {:error, ...}

  """
  def delete_topics_interest(%InterestedinTopics{} = topics_interest) do
    Repo.delete(topics_interest)
  end
end
