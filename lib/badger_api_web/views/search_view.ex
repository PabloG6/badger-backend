defmodule BadgerApiWeb.SearchView do
  use BadgerApiWeb, :view
  alias BadgerApiWeb.SearchView

  def render("index.json", %{search: search}) do
    %{data: render_many(search, SearchView, "search.json")}
  end

  def render("show.json", %{search: search}) do
    %{data: render_one(search, SearchView, "search.json")}
  end

  def render("search.json", %{search: search}) do
    %{id: search.id}
  end
end
