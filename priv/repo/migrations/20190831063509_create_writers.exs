defmodule BadgerApi.Repo.Migrations.CreateWriters do
  use Ecto.Migration

  def change do
    create table(:writers, primary_key: false) do
      add :name, :string
      add :username, :string
      add :email, :string
      add :description, :string
      add :topics_id, references("topics", type: :uuid)
      add :id, :binary_id, primary_key: true
      timestamps()
    end

    create unique_index(:writers, [:username])
    create unique_index(:writers, [:email])
  end
end
