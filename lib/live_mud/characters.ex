defmodule LiveMud.Characters do
  @moduledoc """
  The Characters context.
  """

  import Ecto.Query, warn: false
  alias LiveMud.Repo

  alias LiveMud.Characters.Character

  @doc """
  Returns all characters in the system (admin use only).
  """
  def list_characters do
    Repo.all(Character)
  end

  @doc """
  Returns only the characters owned by the given user.
  """
  def list_characters_by_user(user_id) do
    Character
    |> where([c], c.user_id == ^user_id)
    |> Repo.all()
  end

  @doc """
  Gets a single character.

  Raises `Ecto.NoResultsError` if the Character does not exist.
  """
  def get_character!(id), do: Repo.get!(Character, id)

  @doc """
  Creates a character.
  """
  def create_character(attrs \\ %{}) do
    %Character{}
    |> Character.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a character.
  """
  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a character.
  """
  def delete_character(%Character{} = character) do
    Repo.delete(character)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking character changes.
  """
  def change_character(%Character{} = character, attrs \\ %{}) do
    Character.changeset(character, attrs)
  end
end
