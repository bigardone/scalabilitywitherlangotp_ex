defmodule ScalabilitywitherlangotpEx.Ch3.Behavior.FrequencyText do
  use ExUnit.Case, async: true

  alias ScalabilitywitherlangotpEx.Ch3.Behavior.Frequency

  setup do
    Frequency.start()

    on_exit fn ->
      Frequency.stop()
    end

    :ok
  end

  describe "start/0" do
    test "starts new frequency process" do
      Frequency
      |> Process.whereis
      |> Process.alive?
      |> assert
    end
  end

  describe "stop/0" do
    test "stops frequency server" do
      Frequency.stop()

      refute Process.whereis(Frequency)

      Frequency.start()
    end
  end

  describe "allocate/0" do
    test "returns a free frequency when available" do
      Enum.each(10..15, &(assert {:ok, &1} = Frequency.allocate()))
    end

    test "returns error when no free frequencies" do
      Enum.each(10..15, fn(_) -> Frequency.allocate() end)

      assert {:error, :no_frequency} = Frequency.allocate()
    end
  end

  describe "deallocate/1" do
    test "frees the given frequency" do
      {:ok, frequency} = Frequency.allocate()

      assert :ok = Frequency.deallocate(frequency)

      assert {:ok, ^frequency} = Frequency.allocate()
    end
  end
end
