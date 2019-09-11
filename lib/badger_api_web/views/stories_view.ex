defmodule BadgerApiWeb.StoriesView do
  use BadgerApiWeb, :view
  alias BadgerApiWeb.StoriesView

  def render("index.json", %{stories: stories}) do
    %{data: render_many(stories, StoriesView, "stories.json")}
  end

  def render("show.json", %{stories: stories}) do
    %{data: render_one(stories, StoriesView, "stories.json")}
  end

  def render("stories.json", %{stories: stories}) do
    %{id: stories.id,
      title: stories.title,
      body: stories.body,
      description: stories.description}
  end
end
