defmodule BadgerApiWeb.TopicsView do
  use BadgerApiWeb, :view
  alias BadgerApiWeb.TopicsView

  def render("index.json", %{topics: topics}) do
    %{data: render_many(topics, TopicsView, "topics.json")}
  end

  def render("show.json", %{topics: topics}) do
    %{data: render_one(topics, TopicsView, "topics.json")}
  end

  def render("show_stories.json", %{stories: stories}) do

    %{data: render_many(stories, TopicsView, "stories.json", as: :stories)}
  end

  def render("stories.json", %{stories: stories}) do
    topics = Enum.map(stories.categories, &%{title: &1.title, slug: &1.slug, id: &1.id})
    writer = stories.writer
    %{id: stories.id,
      body: stories.body,
      description: stories.description,
      title: stories.title,
      categories: topics,
      writer: %{
        id: writer.id,
        name: writer.name,
        username: writer.username,

      },


      }
  end

  def render("topics.json", %{topics: topics}) do
    %{id: topics.id,
      title: topics.title,
      slug: topics.slug,
      description: topics.description}
  end


end
