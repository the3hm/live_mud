defmodule LiveMud.CharactersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveMud.Characters` context.
  """

  @doc """
  Generate a character.
  """
  def character_fixture(attrs \\ %{}) do
    {:ok, character} =
      attrs
      |> Enum.into(%{
        avatar: "some avatar",
        description: "some description",
        name: "some name"
      })
      |> LiveMud.Characters.create_character()

    character
  end
end
