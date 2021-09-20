defmodule ExquiLive.LayoutView do
  @moduledoc false
  use ExquiLive.Web, :view

  js_path = Path.join(__DIR__, "../../priv/static/assets/app.js")
  css_path = Path.join(__DIR__, "../../priv/static/assets/app.css")
  uplpot_path = Path.join(__DIR__, "../../priv/static/assets/uPlot.min.css")

  @external_resource js_path
  @external_resource css_path
  @external_resource uplpot_path

  @app_js File.read!(js_path)
  @app_css File.read!(css_path)
  @app_uplot File.read!(uplpot_path)

  def render("app.js", _), do: @app_js
  def render("app.css", _), do: @app_css
  def render("uplot.css", _), do: @app_uplot
end
