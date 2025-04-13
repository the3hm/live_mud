defmodule LiveMud.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :title, :string
      add :description, :text
      add :slug, :string
      add :x, :integer
      add :y, :integer
      add :z, :integer

      timestamps(type: :utc_datetime)
    end

    create unique_index(:rooms, [:slug])
  end
end
