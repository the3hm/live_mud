defmodule LiveMud.Characters.Character do
  @moduledoc """
  Represents a player's in-game avatar, associated with a user and a room.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "characters" do
    field :name, :string
    field :description, :string
    field :avatar, :string

    belongs_to :user, LiveMud.Accounts.User
    belongs_to :room, LiveMud.World.Room

    has_many :posts, LiveMud.World.Post

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :avatar, :description, :user_id, :room_id])
    |> validate_required([:name, :avatar, :description, :user_id, :room_id])
  end
end
