defmodule ScalabilitywitherlangotpEx.Ch3.Behavior.ServerTest do
  use ExUnit.Case

  alias ScalabilitywitherlangotpEx.Ch3.Behavior.{
    Frequency,
    Server
  }

  describe "start/2" do
    test "starts the frequency process" do
      Server.start(Frequency, [])

      Frequency
      |> Process.whereis
      |> Process.alive?
      |> assert

      Server.stop(Frequency)
    end
  end

  describe "stop/1" do
    test "stops server process" do
      Server.start(Frequency, [])
      Server.stop(Frequency)

      assert nil == Process.whereis(Frequency)
    end
  end
end
