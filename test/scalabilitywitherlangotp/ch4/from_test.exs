defmodule ScalabilitywitherlangotpEx.Ch4.FromTest do
  use ExUnit.Case

  alias ScalabilitywitherlangotpEx.Ch4.From

  describe "handle_call({:add, data}, from, _)" do
    test "returns :ok response" do
      {:ok, pid} = GenServer.start(From, 10, [])

      assert :ok = GenServer.call(pid, {:add, 1})
      assert 11 = :sys.get_state(pid)

      GenServer.stop(pid)
    end
  end
end
