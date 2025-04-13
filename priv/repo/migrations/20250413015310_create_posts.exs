defmodule LiveMud.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :text
      add :type, :string
      add :character_id, references(:characters, on_delete: :nothing)
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:posts, [:character_id])
    create index(:posts, [:room_id])
  end
end
