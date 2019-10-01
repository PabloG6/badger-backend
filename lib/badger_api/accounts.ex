defmodule BadgerApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BadgerApi.Repo

  alias BadgerApi.Accounts.Writer

  @doc """
  Returns the list of writers.

  ## Examples

      iex> list_writers()
      [%Writer{}, ...]

  """

  @username_verification ~r/(?<=^|(?<=[^a-zA-Z0-9-_.]))@([A-Za-z]+[A-Za-z0-9-_]+)/
  @email_verification ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
  def list_writers do
    Repo.all(Writer) |> Repo.preload(:writes_about_topics)
  end


  @doc """
  Gets a single writer.

  Raises `Ecto.NoResultsError` if the Writer does not exist.

  ## Examples

      iex> get_writer!(123)
      %Writer{}

      iex> get_writer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_writer!(id), do: Repo.get!(Writer, id) |> Repo.preload(:writes_about_topics)
  def get_writer(id), do: Repo.get(Writer, id) |> Repo.preload(:writes_about_topics)

  @doc """
    returns the profile of the writer
    Raises `Ecto.NoResultsError` if the writer does not exist
    ## Examples
    iex> get_writer_profile!(123)
    %Writer{}
  """
  def get_writer_profile!(id), do: Repo.get(Writer, id) |> Repo.preload(:writes_about_topics)
  def get_writer_profile(id), do: Repo.get(Writer, id) |> Repo.preload(:writes_about_topics)


  @doc """
  Creates a writer.

  ## Examples

      iex> create_writer(%{field: value})
      {:ok, %Writer{}}

      iex> create_writer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_writer(attrs \\ %{}) do
    %Writer{}
    |> Writer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a writer.

  ## Examples

      iex> update_writer(writer, %{field: new_value})
      {:ok, %Writer{}}

      iex> update_writer(writer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_writer(%Writer{} = writer, attrs) do
    writer
    |> Writer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Writer.

  ## Examples

      iex> delete_writer(writer)
      {:ok, %Writer{}}

      iex> delete_writer(writer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_writer(%Writer{} = writer) do
    Repo.delete(writer)
  end


  def authenticate_writer(%{identifier: identifier, password: password}) do
   if Regex.match?(@username_verification, identifier) do
    find_by_username(identifier, password)
   else if Regex.match?(@email_verification, identifier) do
    find_by_email(identifier, password)
   else
    {:error, "Email or username not present in database"}

   end
  end



  end

  defp find_by_username(username, password) do
    query = from(writer in Writer, where: writer.username == ^username)
    query |> Repo.one() |> verify_password(password)
  end

  defp find_by_email(email, password) do
    from(writer in Writer, where: writer.email == ^email) |> Repo.one |> verify_password(password)
  end

  defp verify_password(nil, _) do
    Bcrypt.no_user_verify()
    {:error, "Wrong username, email or password"}
  end

  defp verify_password(writer, password) do
    if Bcrypt.verify_pass(password, writer.password_hash) do
      {:ok, writer}
    else
      {:error, "Wrong username, email or password"}

    end
  end


  @doc """
  Returns an `%Ecto.Changeset{}` for tracking writer changes.

  ## Examples

      iex> change_writer(writer)
      %Ecto.Changeset{source: %Writer{}}

  """
  def change_writer(%Writer{} = writer) do
    Writer.changeset(writer, %{})
  end

  alias BadgerApi.Accounts.Relationships

  @doc """
  Returns the list of followers.

  ## Examples

      iex> followers()
      [%Relationships{}, ...]

  """
  def followers(id) do
    user = Repo.get(Writer, id) |> Repo.preload(:followers)
    user.followers
  end

  def following(id) do

    user = Repo.get(Writer, id) |> Repo.preload(:following)

    user.following

  end



  @doc """
  Follow a user.

  ## Examples

      iex> follow(%{follower_id: writer_id, following_id: other_writer_id})
      {:ok, %Relationships{}}

      iex> follow(%{follower_id: bad_writer_id, following_id: other_writer_id})
      {:error, %Ecto.Changeset{}}

  """
  def follow(current_writer_id, other_writer_id) do

    %Relationships{}
    |> Relationships.changeset(%{follower_id: current_writer_id, following_id: other_writer_id})
    |> Repo.insert()
  end

  def follow!(current_writer_id, other_writer_id) do

  %Relationships{}
  |> Relationships.changeset(%{follower_id: current_writer_id, following_id: other_writer_id})
  |> Repo.insert!()
  end



  @doc """
  Deletes a Relationships.

  ## Examples

      iex> unfollow(123, 457)
      {:ok, %Relationships{}}

      iex> unfollow(124, 4556)
      {:error, %Ecto.Changeset{}}

  """
  def unfollow!(current_writer_id, other_writer_id) do
    relationship = Repo.get_by!(Relationships, follower_id: current_writer_id, following_id: other_writer_id)
    Repo.delete!(relationship)
  end

  def unfollow(current_writer_id, other_writer_id) do
    relationship = Repo.get_by(Relationships, follower_id: current_writer_id, following_id: other_writer_id)
    Repo.delete(relationship)
  end


  def is_following?(current_writer_id, other_writer_id) do
    Repo.get_by(Relationships, follower_id: current_writer_id, following_id: other_writer_id)
  end




  @doc """
  Returns an `%Ecto.Changeset{}` for tracking relationships changes.

  ## Examples

      iex> change_relationships(relationships)
      %Ecto.Changeset{source: %Relationships{}}

  """
  def change_relationships(%Relationships{} = relationships) do
    Relationships.changeset(relationships, %{})
  end
end
