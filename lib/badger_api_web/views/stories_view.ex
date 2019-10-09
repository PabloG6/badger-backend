defmodule BadgerApiWeb.ArticlesView do
  use BadgerApiWeb, :view
  alias BadgerApiWeb.ArticlesView

  def render("index.json", %{articles: articles}) do
    %{data: render_many(articles, ArticlesView, "articles.json")}
  end

  def render("show.json", %{articles: articles}) do
    %{data: render_one(articles, ArticlesView, "articles.json")}
  end

  def render("articles.json", %{articles: articles}) do
    %{
      id: articles.id,
      title: articles.title,
      content: articles.content,
      description: articles.description
    }
  end
end
