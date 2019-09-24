defmodule KcElixirWeb.PageController do
  use KcElixirWeb, :controller

  @meetups [
    %{
      datetime: [
        ~N{2019-10-03 18:00:00},
        ~N{2019-10-03 20:00:00}
      ],
      speaker: %{
        name: "Alan Voss and Sean Cribbs"
      },
      topic: "Game Bot Programming Night",
      location: %{
        url: "https://goo.gl/maps/cUUMbLpFb3Nq4Wiz5",
        address: "300 E 39th St, Kansas City, MO 64111",
        venue: "Plexpod Westport Commons"
      },
      description: """
      You and an optional partner will be creating a bot to play a simple game.  The bots will play against each other at the end of the evening.
      """
    }
  ]

  def index(conn, _params) do
    render(conn, "index.html", meetups: Enum.map(@meetups, &englishify/1))
  end

  def englishify(meetup) do
    # [dt_from, dt_to] = meetup.datetime |> Enum.map(&DateTime.from_naive!(&1, "America/Chicago"))
    [dt_from, dt_to] = meetup.datetime |> Enum.map(&DateTime.from_naive!(&1, "Etc/UTC"))

    # TODO: exclude dates from the past?

    dt_from |> IO.inspect()

    from = Timex.format!(dt_from, "{WDfull}, {Mfull} {D}, {YYYY} - {h12}:{m} {AM}")
    to = Timex.format!(dt_to, "{h12}:{m} {AM}")

    meetup
    |> Map.merge(%{
      date_of: Timex.format!(dt_from, "{WDfull}, {Mfull} {D}, {YYYY}"),
      datetime_description: "#{from} to #{to}",
      location_description: "#{meetup.location.venue} - #{meetup.location.address}"
    })
  end
end
