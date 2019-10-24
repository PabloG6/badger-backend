defmodule BadgerApiWeb.TopicsView do
  use BadgerApiWeb, :view
  alias BadgerApiWeb.TopicsView

  def render("index.json", %{
        topics: topics,
        page_number: page_number,
        page_size: page_size,
        total_entries: total_entries,
        total_pages: total_pages
      }) do
    %{
      data: render_many(topics, TopicsView, "topics.json"),
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    }
  end

  def render("index.json", %{topics: topics}) do
    %{
      data: render_many(topics, TopicsView, "topics.json")
    }
  end

  def render("show.json", %{topics: topics}) do
    %{data: render_one(topics, TopicsView, "topics.json")}
  end

  def render("show_articles.json", %{
        articles: articles,
        page_number: page_number,
        page_size: page_size,
        total_entries: total_entries,
        total_pages: total_pages
      }) do
    %{
      data: render_many(articles, TopicsView, "articles.json", as: :articles),
      page_number: page_number,
      page_size: page_size,
      total_entries: total_entries,
      total_pages: total_pages
    }
  end

  def render("articles.json", %{articles: articles}) do
    topics = Enum.map(articles.categories, &%{title: &1.title, slug: &1.slug, id: &1.id})
    writer = articles.writer

    %{
      id: articles.id,
      content: articles.content,
      description: articles.description,
      title: articles.title,
      categories: topics,
      writer: %{
        id: writer.id,
        name: writer.name,
        username: writer.username
      }
    }
  end

  def render("topics.json", %{topics: topics}) do
    %{id: topics.id, title: topics.title, slug: topics.slug, description: topics.description}
  end
end
