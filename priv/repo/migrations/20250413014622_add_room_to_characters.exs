defmodule LiveMud.Repo.Migrations.AddRoomToCharacters do
  use Ecto.Migration

  def change do
    alter table(:characters) do
      add :room_id, references(:rooms, on_delete: :nothing)
    end

    create index(:characters, [:room_id])
  end
end

