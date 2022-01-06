defmodule KcElixirWeb.PageController do
  use KcElixirWeb, :controller

  @meetups [
    %{
      datetime: [
        ~N{2022-01-06 18:00:00},
        ~N{2022-01-06 20:00:00}
      ],
      speaker: %{
        name: "Bruce Meacham"
      },
      topic: "Using elixir/scenic to build fault tolerant aircraft electrician flight systems.",
      location: %{
        url: "",
        address: "N/A",
        venue: "virtual - zoom"
      },
      description: """
      Join us for using elixir/scenic to build fault tolerant aircraft electrician flight systems.

      If attending virtually please RSVP @ https://www.eventbrite.com/e/elixirscenic-to-build-aircraft-electrician-flight-systems-tickets-239748031817

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
