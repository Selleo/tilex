defmodule Tilex.Repo.Migrations.AddTwitterHandleToDevelopers do
  use Ecto.Migration

  def change do
    alter table(:developers) do
      add :twitter_handle, :string, default: "selleo"
    end
  end
end
