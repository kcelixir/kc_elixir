defmodule KcElixirWeb.PageController do
  use KcElixirWeb, :controller

  @meetups [
    %{
      datetime: [
        ~N{2021-08-05 18:00:00},
        ~N{2021-08-05 20:00:00}
      ],
      speaker: %{
        name: "Jeff Utter"
      },
      topic: "Observability and Monitoring",
      location: %{
        url: "",
        address: "7001 N Locust St, Gladstone, MO 64118",
        venue: "iWorx (classroom near parking lot w/exterior entrance)"
      },
      description: """
      * A smidgen of talking about tools/libraries
      * Some ideas around useful metrics to collect and how to interpret/correlate them
      * One or more stories about how we used metrics to track down a nasty bug and/or make good engineering decisions
      * One or more stories where we used metrics and observability to royally mess something up

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
