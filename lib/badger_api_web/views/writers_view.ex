defmodule BadgerApiWeb.WritersView do
  use BadgerApiWeb, :view
  alias BadgerApiWeb.WritersView

  def render("index.json", %{writer: writers}) do
    %{data: render_many(writers, WritersView, "writers.json")}
  end

  def render("show.json", %{writer: writers}) do
    %{data: render_one(writers, WritersView, "writers.json")}
  end

  def render("writers.json", %{writers: writer}) do
      %{id: writer.id,
      username: writer.username,
      name: writer.name,
      email: writer.email,

      }
  end

  def render("login.json", %{writers: writer, token: token}) do

    %{data: %{
      id: writer.id,
      username: writer.username,
      name: writer.name,
      email: writer.email,
      token: token,

    }}
  end


end
