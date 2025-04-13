defmodule LiveMudWeb.CharacterLive.FormComponent do
  @moduledoc """
  Handles creating and editing a character, scoped to the current user.
  """
  use LiveMudWeb, :live_component

  alias LiveMud.Characters
  alias LiveMud.World

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage character records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="character-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:avatar]} type="text" label="Avatar" />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Character</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{character: character} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Characters.change_character(character))
     end)}
  end

  @impl true
  def handle_event("validate", %{"character" => character_params}, socket) do
    changeset =
      Characters.change_character(socket.assigns.character, character_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("save", %{"character" => character_params}, socket) do
    save_character(socket, socket.assigns.action, character_params)
  end

  defp save_character(socket, :edit, character_params) do
    case Characters.update_character(socket.assigns.character, character_params) do
      {:ok, character} ->
        notify_parent({:saved, character})

        {:noreply,
         socket
         |> put_flash(:info, "Character updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_character(socket, :new, character_params) do
    character_params =
      character_params
      |> Map.put("user_id", socket.assigns.current_user.id)
      |> Map.put("room_id", World.get_starting_room_id())

    case Characters.create_character(character_params) do
      {:ok, character} ->
        notify_parent({:saved, character})

        {:noreply,
         socket
         |> put_flash(:info, "Character created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
