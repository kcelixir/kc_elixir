defmodule KcElixirWeb.PageController do
  use KcElixirWeb, :controller

  @meetups [
    %{
      datetime: [
        ~N{2020-06-04 18:00:00},
        ~N{2020-06-04 20:00:00}
      ],
      speaker: %{
        name: "Alan Voss"
      },
      topic: "Game Night/Live Coding Exercise",
      location: %{
        url: "https://www.eventbrite.com/e/kc-elixir-group-game-bot-night-tickets-98729413333",
        address: "",
        venue: "virtual - zoom"
      },
      description: """
      This meeting will be held virtually. Call in details will be included with your registration confirmation.

      Sign up at eventbrite: https://www.eventbrite.com/e/kc-elixir-group-game-bot-night-tickets-98729413333

      You can join our group's Slack by going to http://kcelixir-slack.herokuapp.com/.
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
