defmodule LiveMud.World.Post do
  @moduledoc """
  A Post represents a timeline entry in a room: speech, emote, combat log, or system event.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :type, :string # "say", "emote", "system", etc.

    belongs_to :character, LiveMud.Characters.Character
    belongs_to :room, LiveMud.World.Room

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :type, :character_id, :room_id])
    |> validate_required([:body, :type, :character_id, :room_id])
    |> validate_inclusion(:type, ["say", "emote", "system", "combat"])
  end
end
