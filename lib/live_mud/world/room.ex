defmodule LiveMud.World.Room do
  @moduledoc """
  A Room in the MUD world, containing description and coordinates.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :title, :string
    field :description, :string
    field :slug, :string
    field :x, :integer
    field :y, :integer
    field :z, :integer

    has_many :characters, LiveMud.Characters.Character

    has_many :posts, LiveMud.World.Post


    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:title, :description, :slug, :x, :y, :z])
    |> validate_required([:title, :description, :slug])
    |> unique_constraint(:slug)
  end
end
