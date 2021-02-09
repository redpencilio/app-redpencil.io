defmodule Dispatcher do
  use Plug.Router

  def start(_argv) do
    port = 80
    IO.puts "Starting Plug with Cowboy on port #{port}"
    Plug.Adapters.Cowboy.http __MODULE__, [], port: port
    :timer.sleep(:infinity)
  end

  plug Plug.Logger
  plug :match
  plug :dispatch


  ###############################################################
  # master-email-domain.lisp
  ###############################################################
  post "/email-delivery/*path" do
    Proxy.forward conn, path, "http://deliver-email-service/email-delivery/"
  end

  get "/mail-folders/*path" do
    Proxy.forward conn, path, "http://resource/mail-folders/"
  end

  post "/emails/*path" do
    Proxy.forward conn, path, "http://resource/emails/"
  end

  match _ do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
