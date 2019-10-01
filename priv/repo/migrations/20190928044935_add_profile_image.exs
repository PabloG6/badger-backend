defmodule BadgerApi.Repo.Migrations.AddProfileImage do
  use Ecto.Migration

  def change do
    alter table(:writers) do
      add :avatar, :string
    end
  end
end
