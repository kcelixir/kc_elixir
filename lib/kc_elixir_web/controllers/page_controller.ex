defmodule KcElixirWeb.PageController do
  use KcElixirWeb, :controller

  @meetups [
    %{
      datetime: [
        ~N{2021-10-07 18:00:00},
        ~N{2021-10-07 20:00:00}
      ],
      speaker: %{
        name: "Alan Voss"
      },
      topic: "Bot creation fun (game bot)",
      location: %{
        url: "",
        address: "7001 N Locust St, Gladstone MO 64118 - ping in slack if you are locked out",
        venue: "in person/virtual - zoom"
      },
      description: """
      Join us for another entertaining evening of bot creation.  Program your own or pair up with a neighbor.  We will duke it out for champion at the end.  Bring a friend who has never done Elixir!

      If attending virtually please RSVP @ https://www.eventbrite.com/e/bot-creation-fun-with-alan-voss-tickets-182150044687

      You can join our group's Slack by going to http://kcelixir-slack.herokuapp.com/.
      """,
      sponsors: []
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
