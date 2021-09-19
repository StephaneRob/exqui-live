defmodule ExquiLive.Helper do
  # General helpers for live views (not-rendering related).
  @moduledoc false

  @doc """
  Computes a route path to the live dashboard.
  """
  def exqui_live_path(socket, action, params) do
    apply(
      socket.router.__helpers__(),
      :exqui_live_path,
      [socket, action, params]
    )
  end

  def exqui_live_path(socket, action) do
    apply(
      socket.router.__helpers__(),
      :exqui_live_path,
      [socket, action]
    )
  end
end
