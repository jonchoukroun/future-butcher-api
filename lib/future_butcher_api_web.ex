defmodule FutureButcherApiWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use FutureButcherApiWeb, :controller
      use FutureButcherApiWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: FutureButcherApiWeb
      import Plug.Conn
      import FutureButcherApiWeb.Router.Helpers
      import FutureButcherApiWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/<%= lib_web_name %>/templates",
        namespace: <%= web_namespace %>

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      unquote(view_helpers())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {<%= web_namespace %>.LayoutView, "live.html"}

        unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.HTML
      import Phoenix.LiveView.Helpers
      import Phoenix.View
      import FutureButcherApiWeb.ErrorHelpers
      import FutureButcherApiWeb.Gettext
      alias FutureButcherApiWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import FutureButcherApiWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
