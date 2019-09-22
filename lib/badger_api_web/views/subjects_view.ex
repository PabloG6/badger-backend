defmodule BadgerApiWeb.SubjectsView do
  use BadgerApiWeb, :view
  alias BadgerApiWeb.SubjectsView

  def render("index.json", %{subjects: subjects}) do
    %{data: render_many(subjects, SubjectsView, "subjects.json")}
  end

  def render("show.json", %{subjects: subjects}) do
    %{data: render_one(subjects, SubjectsView, "subjects.json")}
  end

  def render("subjects.json", %{subjects: subjects}) do
    %{id: subjects.id}
  end
end
