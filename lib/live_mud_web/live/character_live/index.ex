defmodule LiveMudWeb.CharacterLive.Index do
  @moduledoc """
  Displays a list of characters and allows creating/editing/deleting.
  """

  use LiveMudWeb, :live_view

  alias LiveMud.Characters
  alias LiveMud.Characters.Character

  @impl true
  def mount(_params, _session, socket) do
    characters = Characters.list_characters_by_user(socket.assigns.current_user.id)

    {:ok,
     socket
     |> stream(:characters, characters)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    case socket.assigns.live_action do
      :edit ->
        character = Characters.get_character!(params["id"])

        {:noreply,
         socket
         |> assign(:page_title, "Edit Character")
         |> assign(:character, character)}

      :new ->
        {:noreply,
         socket
         |> assign(:page_title, "New Character")
         |> assign(:character, %Character{})}

      :index ->
        {:noreply,
         socket
         |> assign(:page_title, "Listing Characters")
         |> assign(:character, nil)}
    end
  end

  @impl true
  def handle_info({LiveMudWeb.CharacterLive.FormComponent, {:saved, character}}, socket) do
    {:noreply, stream_insert(socket, :characters, character)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    character = Characters.get_character!(id)
    {:ok, _} = Characters.delete_character(character)

    {:noreply, stream_delete(socket, :characters, character)}
  end
end
