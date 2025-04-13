defmodule LiveMudWeb.CharacterLive.Index do
  @moduledoc """
  Lists and manages characters for the logged-in user.
  """
  use LiveMudWeb, :live_view

  alias LiveMud.Characters
  alias LiveMud.Characters.Character

  @impl true
  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    characters = Characters.list_characters_by_user(current_user.id)

    {:ok,
     socket
     |> assign(:current_user, current_user)
     |> stream(:characters, characters)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Character")
    |> assign(:character, Characters.get_character!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Character")
    |> assign(:character, %Character{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Characters")
    |> assign(:character, nil)
  end

  @impl true
  def handle_info({LiveMudWeb.CharacterLive.FormComponent, {:saved, character}}, socket) do
    {:noreply, stream_insert(socket, :characters, character)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    character = Characters.get_character!(id)

    if character.user_id == socket.assigns.current_user.id do
      {:ok, _} = Characters.delete_character(character)
      {:noreply, stream_delete(socket, :characters, character)}
    else
      {:noreply, put_flash(socket, :error, "You can't delete this character.")}
    end
  end
end
