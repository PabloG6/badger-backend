defmodule BadgerApiWeb.WritersView do
  use BadgerApiWeb, :view
  alias BadgerApiWeb.WritersView
  alias BadgerApi.Repo

  def render("index.json", %{writer: writers}) do
    %{data: render_many(writers, WritersView, "writers.json")}
  end

  def render("index.json", %{
        writer: writers,
        page_size: page_size,
        page_number: page_number,
        total_pages: total_pages,
        total_entries: total_entries
      }) do
    %{
      data: render_many(writers, WritersView, "writers.json"),
      page_size: page_size,
      page_number: page_number,
      total_pages: total_pages,
      total_entrie: total_entries
    }
  end

  def render("show.json", %{writer: writers}) do
    %{data: render_one(writers, WritersView, "writers.json")}
  end

  def render("writers.json", %{writers: writer}) do
    writer = writer |> Repo.preload(:writes_about_topics)

    writes_about_topics =
      Enum.map(
        writer.writes_about_topics,
        &%{title: &1.title, description: &1.description, slug: &1.slug}
      )


    %{
      id: writer.id,
      username: writer.username,
      name: writer.name,
      email: writer.email,
      writes_about_topics: writes_about_topics
    }
  end

  def render("login.json", %{writers: writer, token: token}) do
    writer = writer |> Repo.preload(:writes_about_topics)

    writes_about_topics =
      Enum.map(
        writer.writes_about_topics,
        &%{title: &1.title, description: &1.description, slug: &1.slug}
      )



    %{
      data: %{
        id: writer.id,
        username: writer.username,
        name: writer.name,
        email: writer.email,
        token: token,
        writes_about_topics: writes_about_topics
      }
    }
  end
end
