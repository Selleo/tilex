defmodule Tilex.Repo.Migrations.AddIsPublicColumnToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :is_public, :boolean, default: false, null: false
    end
  end
end
