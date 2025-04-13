defmodule LiveMud.World do
  @moduledoc """
  The World context for managing rooms and posts.
  """

  import Ecto.Query
  alias LiveMud.Repo

  alias LiveMud.World.Room
  alias LiveMud.World.Post

  @doc """
  Gets or creates the starting room.
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

  @doc """
  Returns the latest posts for a room.
  """
  def list_recent_posts(room_id, limit \\ 30) do
    Post
    |> where([p], p.room_id == ^room_id)
    |> order_by([desc: :inserted_at])
    |> limit(^limit)
    |> preload(:character)
    |> Repo.all()
    |> Enum.reverse()
  end

  @doc """
  Creates a new post in the room timeline.
  """
  def create_post(attrs) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end
end
