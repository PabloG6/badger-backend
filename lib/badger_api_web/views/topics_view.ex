defmodule BadgerApiWeb.TopicsView do
  use BadgerApiWeb, :view
  alias BadgerApiWeb.TopicsView

  def render("index.json", %{topics: topics}) do
    %{data: render_many(topics, TopicsView, "topics.json")}
  end

  def render("show.json", %{topics: topics}) do
    %{data: render_one(topics, TopicsView, "topics.json")}
  end

  def render("topics.json", %{topics: topics}) do
    %{id: topics.id,
      title: topics.title,
      description: topics.description}
  end


end
