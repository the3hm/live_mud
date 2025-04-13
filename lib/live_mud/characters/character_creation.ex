defmodule LiveMud.Characters.CharacterCreation do
  @moduledoc """
  Handles logic for creating new characters with validation, defaults, and ownership enforcement.
  """

  alias LiveMud.Characters.Character
  alias LiveMud.Repo
  alias LiveMud.World

  import Ecto.Changeset

  @doc """
  Builds a changeset for a new character with default values.

  ## Examples

      iex> CharacterCreation.build_changeset(%User{id: 1}, %{})
      %Ecto.Changeset{}

  """
  def build_changeset(user, attrs \\ %{}) do
    %Character{}
    |> Character.changeset(attrs)
    |> put_change(:user_id, user.id)
    |> put_default_room()
    |> put_default_avatar()
  end

  @doc """
  Creates a character with validated changes.

  Returns `{:ok, character}` or `{:error, changeset}`.

  ## Examples

      iex> CharacterCreation.create(user, %{"name" => "Eko", "avatar" => "eko.png"})
      {:ok, %Character{}}

  """
  def create(user, attrs) do
    build_changeset(user, attrs)
    |> Repo.insert()
  end

  defp put_default_room(changeset) do
    room_id = World.get_starting_room_id()
    put_change(changeset, :room_id, room_id)
  end

  defp put_default_avatar(changeset) do
    case get_field(changeset, :avatar) do
      nil -> put_change(changeset, :avatar, "default.png")
      _ -> changeset
    end
  end
end
