defmodule BadgerApi.Repo.Migrations.CreateWritesAboutTopics do
  use Ecto.Migration

  def change do
    rename table(:writers_topics), to: table(:writes_about_topics)
    rename table(:topics_interests), to: table(:interested_in_topics)


  end
end
