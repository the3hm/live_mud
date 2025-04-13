defmodule LiveMudWeb.RoomLive.Timeline do
  @moduledoc """
  The room-based timeline feed. Shows posts and allows creating new ones.
  """

  use LiveMudWeb, :live_view

  alias LiveMud.World
  alias LiveMud.Repo
  alias LiveMudWeb.FeedComponents
  import FeedComponents

  @impl true
  def mount(_params, _session, socket) do
    case socket.assigns.current_user.characters do
      [character | _] ->
        if connected?(socket), do: Phoenix.PubSub.subscribe(LiveMud.PubSub, topic(character.room_id))

        posts = World.list_recent_posts(character.room_id)

        {:ok,
         socket
         |> assign(:character, character)
         |> assign(:room_id, character.room_id)
         |> assign(:posts, posts)
         |> assign(:message, "")}

      [] ->
        {:ok,
         socket
         |> put_flash(:error, "You must create a character before entering the room.")
         |> redirect(to: ~p"/characters/new")}
    end
  end

  @impl true
  def handle_event("submit", %{"message" => message}, socket) do
    character = socket.assigns.character
    trimmed = String.trim_leading(message)

    cond do
      # /emote
      String.starts_with?(trimmed, "/emote") ->
        emote = String.trim_leading(String.replace_prefix(trimmed, "/emote", ""))
        create_and_broadcast_post("emote", emote, character)
        {:noreply, assign(socket, :message, "")}

      # /look
      trimmed == "/look" ->
        room = Repo.get!(World.Room, character.room_id)
        system_msg = "**#{room.title}**\n#{room.description}"
        create_and_broadcast_post("system", system_msg, character)
        {:noreply, assign(socket, :message, "")}

      # fallback say
      true ->
        create_and_broadcast_post("say", message, character)
        {:noreply, assign(socket, :message, "")}
    end
  end

  defp create_and_broadcast_post(type, body, character) do
    {:ok, post} =
      World.create_post(%{
        body: body,
        type: type,
        character_id: character.id,
        room_id: character.room_id
      })

    Phoenix.PubSub.broadcast(
      LiveMud.PubSub,
      topic(post.room_id),
      {:new_post, Repo.preload(post, :character)}
    )
  end

  @impl true
  def handle_info({:new_post, post}, socket) do
    {:noreply, update(socket, :posts, fn posts -> posts ++ [post] end)}
  end

  defp topic(room_id), do: "room:#{room_id}"
end
