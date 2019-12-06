# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BadgerApi.Repo.insert!(%BadgerApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import BadgerApi.Factory
alias BadgerApi.Repo
alias BadgerApi.Badge.Topics

topics = [
  "tech",
  "lifestyle",
  "money",
  "politics",
  "food",
  "fashion",
  "business",
  "art",
  "music",
  "science",
  "hardware",
  "law",
  "capitalism",
  "cryptography",
  "cryptocurrency",
  "makeup",
  "products",
  "product reviews",
  "podcast",
  "games",
  "coding",
  "javascript",
  "painting",
  "restaurant reviews",
  "product reviews",
  "history",
  "rhythm and blues",
  "dancehall",
  "reggae",
  "soca",
  "software engineering",
  "ux design",
  "UI Design"
]

defmodule Seeds do
  def create_topics(topic_title), do: insert(:topics, title: topic_title)

  defp randomize_topics() do
    repo_topics = Repo.all(Topics)
    mapify = &%{id: &1.id, title: &1.title, slug: &1.slug, description: &1.description}

    for(
      _ <- 0..4,
      do:
        params_with_assocs(
          :topics,
          Enum.at(
            repo_topics,
            :rand.uniform(length(repo_topics))
          )
          |> mapify.()
        )
    )
  end

  defp create_articles(writer) do
    insert_list(5, :articles, writer: writer, categories: randomize_topics())
  end

  def initialize do
    Enum.map(insert_list(5, :writer), &create_articles/1)
  end
end

IO.inspect(Seeds.initialize())
