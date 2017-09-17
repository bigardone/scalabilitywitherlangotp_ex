defmodule ScalabilitywitherlangotpEx.Ch3.PatternText do
  use ExUnit.Case

  alias ScalabilitywitherlangotpEx.Ch3.Pattern

  describe "start/1" do
    test "starts new server process returning its PID" do
      pid = Pattern.start([])

      assert is_pid(pid)
      assert Process.alive?(pid)
    end
  end
end
