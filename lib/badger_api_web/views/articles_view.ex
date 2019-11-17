defmodule BadgerApiWeb.ArticlesView do
  use BadgerApiWeb, :view
  alias BadgerApiWeb.ArticlesView
  alias BadgerApi.Publications.Articles
  alias BadgerApi.Repo
  alias Exsolr

  def render("index.json", %{
        articles: articles,
        total_entries: total_entries,
        page_size: page_size,
        total_pages: total_pages,
        page_number: page_number
      }) do
    %{
      data: render_many(articles, ArticlesView, "articles.json"),
      total_entries: total_entries,
      page_size: page_size,
      total_pages: total_pages,
      page_number: page_number
    }
  end

  def render("index.json", %{articles: articles}) do
    %{
      data: render_many(articles, ArticlesView, "articles.json")
    }
  end

  def render("show.json", %{articles: articles}) do
    %{data: render_one(articles, ArticlesView, "articles.json")}
  end

  def render("articles.json", %{articles: articles}) do
    articles = articles |> Repo.preload([:writer, :categories])
    writer = &%{name: &1.name, username: &1.username, email: &1.email, avatar: &1.avatar}

    categories = fn categories ->
      Enum.map(categories, &%{title: &1.title, description: &1.description, slug: &1.slug})
    end

    %{
      id: articles.id,
      title: articles.title,
      content: articles.content,
      description: articles.description,
      writer: writer.(articles.writer),
      categories: categories.(articles.categories)
    }
  end
end
