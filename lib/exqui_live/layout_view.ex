defmodule ExquiLive.LayoutView do
  @moduledoc false
  use ExquiLive.Web, :view

  js_path = Path.join(__DIR__, "../../priv/static/assets/app.js")
  @external_resource js_path
  @app_js File.read!(js_path)

  def render("app.js", _), do: @app_js
end
