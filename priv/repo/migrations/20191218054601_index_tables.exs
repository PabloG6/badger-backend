defmodule BadgerApi.Repo.Migrations.IndexTables do
  use Ecto.Migration

  def up do
    create index(:categories_articles, [:articles_id])
    create index(:categories_articles, [:categories_id])

    create index(:interested_in_topics, [:writer_id])
    create index(:interested_in_topics, [:topics_id])


    create index(:writes_about_topics, [:topics_id])
    create index(:writes_about_topics, [:writer_id])

    create index(:relationships, [:follower_id])
    create index(:relationships, [:following_id])

  end

  def down do
    drop index(:categories_articles, [:articles_id])
    drop index(:categories_articles, [:categories_id])

    drop index(:interested_in_topics, [:writer_id])
    drop index(:interested_in_topics, [:topics_id])

    drop index(:writes_about_topics, [:topics_id])
    drop index(:writes_about_topics, [:writer_id])

    drop index(:relationships, [:follower_id])
    drop index(:relationships, [:following_id])
  end
end
