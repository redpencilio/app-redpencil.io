defmodule Dispatcher do
  use Matcher

  define_accept_types [
    json: [ "application/json", "application/vnd.api+json" ],
    html: [ "text/html", "application/xhtml+html" ],
    any: ["*/*"]
  ]

  @json %{ accept: %{ json: true } }
  @turtle %{ accept: %{ turtle: true } }
  @any %{ accept: %{ any: true } }
  @html %{ accept: %{ html: true } }

  post "/email-delivery/*path", @any do
    forward conn, path, "http://deliver-email-service/email-delivery/"
  end

  post "/emails/*path", @any do
    forward conn, path, "http://resource/emails/"
  end

  get "/favicon.ico", @any do
    send_resp( conn, 404, "" )
  end

  get "/assets/*path", @any do
    forward conn, path, "http://frontend/assets/"
  end

  get "/*path", @html do
    forward conn, path, "http://frontend/"
  end

  #################################################################
  # 404
  #################################################################

  match "/*_", %{ last_call: true } do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
