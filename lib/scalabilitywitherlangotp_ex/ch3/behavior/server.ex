defmodule ScalabilitywitherlangotpEx.Ch3.Behavior.Server do
  @moduledoc """
  https://github.com/francescoc/scalabilitywitherlangotp/blob/master/ch3/behavior/server.erl
  """

  def start(name, args) do
    __MODULE__
    |> spawn(:init, [name, args])
    |> Process.register(name)
  end

  def stop(name) do
    send(name, {:stop, self()})

    receive do
      {:reply, response} -> response
    end
  end

  def init(mod, args) do
    state = mod.init(args)

    loop(mod, state)
  end

  def call(name, msg) do
    send(name, {:request, self(), msg})

    receive do
      {:reply, response} -> response
    end
  end

  defp reply(to, response), do: send(to, {:reply, response})

  defp loop(mod, state) do
    receive do
      {:request, from, msg} ->
        {new_state, response} = mod.handle(msg, state)
        reply(from, response)
        loop(mod, new_state)

      {:stop, from} ->
        response = mod.terminate(state)
        reply(from, response)
    end
  end
end
