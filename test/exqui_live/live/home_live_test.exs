defmodule ExquiLive.HomeLiveTest do
  use ExquiLive.ConnCase
  import Phoenix.LiveViewTest

  test "try to mount home", %{conn: conn} do
    {:ok, view, html} = live(conn, "/exqui")
    assert view |> element(".chart-container") |> has_element?()
    assert view |> element(".stats") |> has_element?()
  end
end
