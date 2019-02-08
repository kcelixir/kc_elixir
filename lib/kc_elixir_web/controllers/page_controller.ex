defmodule KcElixirWeb.PageController do
  use KcElixirWeb, :controller

  @meetups [
    %{
      datetime: [
        ~N{2019-03-07 18:00:00},
        ~N{2019-03-07 20:00:00}
      ],
      image_url: "http://placekitten.com/200/200",
      topic: "Dialyzer!",
      location: %{
        url: "http://www.403club.com",
        address: "614 Reynolds Ave, Kansas City, KS 66101",
        venue: "403 Club"
      },
      description: """
      It is time that we got to know each other for more than
      just our brains and Alan's great rapping skills. Let's get on down
      to the 403 Club for some libations and games. They have pool,
      darts, and no shortage of pinball. We look forward to seeing
      everyone there. Alcohol is not a requirement for anyone to drink.
      """
    }
  ]

  def index(conn, _params) do
    render(conn, "index.html", meetups: Enum.map(@meetups, &englishify/1))
  end

  def englishify(meetup) do
    # [dt_from, dt_to] = meetup.datetime |> Enum.map(&DateTime.from_naive!(&1, "America/Chicago"))
    [dt_from, dt_to] = meetup.datetime |> Enum.map(&DateTime.from_naive!(&1, "Etc/UTC"))

    # TODO: exclude dates that in the past

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
