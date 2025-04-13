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
        <:subtitle>Create or edit a character to enter the world of LiveMud.</:subtitle>
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
  def update(%{character: nil} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Characters.change_character(assigns.current_user))
     end)}
  end

  def update(%{character: character} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Characters.change_character(character))
     end)}
  end

  @impl true
  def handle_event("validate", %{"character" => params}, socket) do
    changeset =
      case socket.assigns.character do
        nil -> Characters.change_character(socket.assigns.current_user, params)
        %{} -> Characters.change_character(socket.assigns.character, params)
      end

    {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
  end

  @impl true
  def handle_event("save", %{"character" => params}, socket) do
    save_character(socket, socket.assigns.action, params)
  end

  defp save_character(socket, :edit, params) do
    case Characters.update_character(socket.assigns.character, params) do
      {:ok, character} ->
        notify_parent({:saved, character})

        {:noreply,
         socket
         |> put_flash(:info, "Character updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_character(socket, :new, params) do
    case Characters.create_character(socket.assigns.current_user, params) do
      {:ok, character} ->
        notify_parent({:saved, character})

        {:noreply,
         socket
         |> put_flash(:info, "Character created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
