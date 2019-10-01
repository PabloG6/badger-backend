defmodule BadgerApi.Context do
  @moduledoc """
  The Context context.
  """

  import Ecto.Query, warn: false
  alias BadgerApi.Repo
  alias BadgerApi.Accounts.Writer
  alias BadgerApi.Context.TopicsInterest

  @doc """
  Returns the list of topics_interest.

  ## Examples

      iex> list_topics_interest()
      [%TopicsInterest{}, ...]

  """
  def list_topics_interest(id) do
    writer = Repo.get(Writer, id) |> Repo.preload(:interested_in_topics)
    writer.interested_in_topics
  end



  @doc """
  checks if the user is following this topic
  iex> is_following?(writer_id, topics_id)
  true
  """

  def is_following?(writer_id, topics_id) do
    Repo.exists? from TopicsInterest, where: [writer_id: ^writer_id, topics_id: ^topics_id]
  end

  def get_topics_interest(id) do
    Repo.get(TopicsInterest, id)
  end

  def get_specific_topics_interest!(writer_id, topics_id), do: Repo.get_by!(TopicsInterest, [writer_id: writer_id, topics_id: topics_id])
  def get_topics_interest!(id) do
    Repo.get!(TopicsInterest, id)
  end
  @doc """
  Creates a topics_interest.

  ## Examples

      iex> create_topics_interest(%{field: value})
      {:ok, %TopicsInterest{}}

      iex> create_topics_interest(%{field: bad_value})
      {:error, ...}

  """
  def create_topics_interest(attrs \\ %{}) do
    TopicsInterest.changeset(%TopicsInterest{}, attrs)
    |> Repo.insert
  end


  @doc """
  Deletes a TopicsInterest.

  ## Examples

      iex> delete_topics_interest(topics_interest)
      {:ok, %TopicsInterest{}}

      iex> delete_topics_interest(topics_interest)
      {:error, ...}

  """
  def delete_topics_interest(%TopicsInterest{} = topics_interest) do
    Repo.delete(topics_interest)
  end


end
