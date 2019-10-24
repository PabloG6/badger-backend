defmodule BadgerApiWeb.RelationshipsView do
  use BadgerApiWeb, :view
  alias BadgerApiWeb.RelationshipsView

  def render("index.json", %{relationships: relationships}) do
    %{data: render_many(relationships, RelationshipsView, "relationships.json")}
  end

  def render("followers.json", %{
        followers: followers,
        total_pages: total_pages,
        total_entries: total_entries,
        page_size: page_size,
        page_number: page_number
      }) do
    %{
      data: render_many(followers, RelationshipsView, "follower.json", as: :writers),
      total_pages: total_pages,
      total_entries: total_entries,
      page_size: page_size,
      page_number: page_number
    }
  end

  def render("following.json", %{
        subjects: subjects,
        total_pages: total_pages,
        total_entries: total_entries,
        page_size: page_size,
        page_number: page_number
      }) do
    %{
      data: render_many(subjects, RelationshipsView, "subject.json", as: :writer),
      total_entries: total_entries,
      total_pages: total_pages,
      page_size: page_size,
      page_number: page_number
    }
  end

  def render("follower.json", %{writers: writer}) do
    %{
      id: writer.id,
      username: writer.username,
      name: writer.name
    }
  end

  def render("subject.json", %{writer: writer}) do
    %{
      id: writer.id,
      username: writer.username,
      name: writer.name
    }
  end

  def render("show.json", %{relationships: relationships}) do
    %{data: render_one(relationships, RelationshipsView, "relationships.json")}
  end

  def render("relationships.json", %{relationships: relationships}) do
    %{
      id: relationships.id,
      follower_id: relationships.follower_id,
      following_id: relationships.following_id
    }
  end
end
