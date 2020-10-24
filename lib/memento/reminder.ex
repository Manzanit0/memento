defmodule Memento.Reminder do
  use GenServer

  import Ecto.Query
  alias Memento.Repo
  alias Memento.Users.Contact

  @default_minutes 3

  def start_link(args \\ []) do
    GenServer.start_link(__MODULE__, to_map(args))
  end

  defp to_map(args) do
    %{
      minutes: Keyword.get(args, :minutes, @default_minutes),
      forever: Keyword.get(args, :forever, true)
    }
  end

  @impl true
  def init(%{minutes: minutes} = state) do
    schedule_work(minutes)
    {:ok, state}
  end

  @impl true
  def handle_info(:work, %{minutes: minutes, forever: forever} = state) do
    todays_birthday()

    if forever do
      schedule_work(minutes)
    end

    {:noreply, state}
  end

  defp schedule_work(minutes) do
    milliseconds = to_milliseconds(minutes)
    Process.send_after(self(), :work, milliseconds)
  end

  defp to_milliseconds(minutes) do
    minutes
    |> :timer.minutes()
    |> Kernel.trunc()
  end

  def todays_birthday() do
    from(c in Contact, where: c.birthdate == ^Date.utc_today())
    |> Repo.all()
  end
end
