defmodule LiveMud.Characters do
  @moduledoc """
  The Characters context.
  """

  import Ecto.Query, warn: false
  alias LiveMud.Repo
  alias LiveMud.Characters.{Character, CharacterCreation}

  # ...

  @doc """
  Creates a new character for the given user.

  ## Examples

      iex> create_character(user, attrs)
      {:ok, %Character{}}
  """
  def create_character(user, attrs \\ %{}) do
    CharacterCreation.create(user, attrs)
  end

@doc """
Returns an `%Ecto.Changeset{}` for tracking character changes.
"""
def change_character(character, attrs \\ %{})
def change_character(nil, attrs), do: change_character(%Character{}, attrs)
def change_character(%Character{} = character, attrs), do: Character.changeset(character, attrs)

end
