defmodule BullsWeb.GameChannel do
  use BullsWeb, :channel

  @moduledoc """
  Channel for the browser logic of Bulls and Cows.
  Referred to https://github.com/NatTuck/scratch-2021-01/blob/master/4550/0209/hangman/lib/hangman_web/channels/game_channel.ex
  """

  alias Bulls.Game

  @impl true
  def join("game:" <> _id, payload, socket) do
    if authorized?(payload) do
      game = Game.new()
      socket = assign(socket, :game, game)
      view = Game.view(game)
      {:ok, view, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("guess", %{"number" => n}, socket) do
    game_prev = socket.assigns[:game]
    game_cur = Game.guess(game_prev, n)
    socket = assign(socket, :game, game_cur)
    view = Game.view(game_cur)
    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_in("reset", _, socket) do
    game = Game.new()
    socket = assign(socket, :game, game)
    view = Game.view(game)
    {:reply, {:ok, view}, socket}
  end

  # No special authorization for this game
  defp authorized?(_payload) do
    true
  end
end
