defmodule LiveMud.World do
  @moduledoc """
  The World context for managing rooms and spatial logic.
  """

  import Ecto.Query
  alias LiveMud.Repo
  alias LiveMud.World.Room

  @doc """
  Returns the ID of the starting room. Creates it if it doesn't exist.
  """
  def get_starting_room_id do
    case Repo.get_by(Room, slug: "starting-room") do
      nil ->
        {:ok, room} =
          %Room{}
          |> Room.changeset(%{
            slug: "starting-room",
            title: "Arrival Platform",
            description: "A circular room shimmering with energy. This is where your journey begins.",
            x: 0, y: 0, z: 0
          })
          |> Repo.insert()

        room.id

      room ->
        room.id
    end
  end
end
