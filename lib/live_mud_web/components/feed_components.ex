defmodule LiveMudWeb.FeedComponents do
  @moduledoc """
  UI components for rendering timeline posts in the room feed.
  """

  use Phoenix.Component

  def post_card(assigns) do
    ~H"""
    <div class="bg-zinc-800 p-4 rounded-lg shadow">
      <%= case @post.type do %>
        <% "say" -> %>
          <p class="text-sm text-gray-400 mb-1">
            <%= @post.character.name %>
            <span class="text-gray-500">— <%= format_time(@post.inserted_at) %></span>
          </p>
          <p class="text-white"><%= @post.body %></p>

        <% "emote" -> %>
          <p class="text-sm text-rose-300 italic mb-1">
            * <%= @post.character.name %> <%= @post.body %>
            <span class="text-xs text-gray-500">[<%= format_time(@post.inserted_at) %>]</span>
          </p>

        <% "system" -> %>
          <p class="text-center text-xs text-gray-400 italic whitespace-pre-line">
            <%= @post.body %>
          </p>

        <% _ -> %>
          <p class="text-sm text-white"><%= @post.character.name %>: <%= @post.body %></p>
      <% end %>
    </div>
    """
  end

  defp format_time(datetime) do
    Timex.from_now(datetime)
  end
end
