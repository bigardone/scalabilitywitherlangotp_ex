defmodule ScalabilitywitherlangotpEx.Ch3.Pattern do
  @moduledoc """
  https://github.com/francescoc/scalabilitywitherlangotp/blob/master/ch3/pattern.erl
  """

  @doc """
  Start the server
  """
  def start(args) do
    spawn(__MODULE__, :init, [args])
  end

  @doc """
  Initialize internal process state
  """
  def init(args) do
    args
    |> initialize_state
    |> loop
  end

  # Receive and handle messages
  defp loop(state) do
    receive do
      {:handle, msg} ->
        new_state = handle(msg, state)
        loop(new_state)

      :stop ->
        terminate(state)
    end
  end

  # Cleanup prior to termination
  defp terminate(state), do: clean_up(state)

  #TODO: Fill in specific server code
  def handle(_, _), do: :ok

  def initialize_state(_), do: :ok

  def clean_up(_), do: :ok
end
