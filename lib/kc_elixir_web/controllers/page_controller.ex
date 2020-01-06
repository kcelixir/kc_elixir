defmodule KcElixirWeb.PageController do
  use KcElixirWeb, :controller

  @meetups [
    %{
      datetime: [
        ~N{2020-01-09 18:00:00},
        ~N{2020-01-09 20:00:00}
      ],
      speaker: %{
        name: "Multiple speakers"
      },
      topic: "Lightning Talks",
      location: %{
        url: "https://goo.gl/maps/cUUMbLpFb3Nq4Wiz5",
        address: "300 E 39th St, Kansas City, MO 64111",
        venue: "Plexpod Westport Commons, Room 1M"
      },
      description: """
      5 minute presentations on various Elixir and non-Elixir topics put on by the group.

      Park in the ramped Guest Parking Lot at the NE corner of 39th and Warwick.  The building for the meetup is the one that is sky-bridged from the building adjacent to the parking lot and then on the 1st floor of that building.  Upon arrival, reach out to @alanvoss or @seancribbs in the #general channel of KC Elixir Slack, and we'll come get you and guide you.  You can join our group's Slack by going to http://kcelixir-slack.herokuapp.com/.
      """,
      sponsors: [
        %{ name: "Postmates", image: "postmates.png", url: "https://postmates.com" },
      ]
    }
  ]

  def index(conn, _params) do
    render(conn, "index.html", meetups: Enum.map(@meetups, &englishify/1))
  end

  def englishify(meetup) do
    # [dt_from, dt_to] = meetup.datetime |> Enum.map(&DateTime.from_naive!(&1, "America/Chicago"))
    [dt_from, dt_to] = meetup.datetime |> Enum.map(&DateTime.from_naive!(&1, "Etc/UTC"))

    # TODO: exclude dates from the past?

    # dt_from |> IO.inspect()

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
