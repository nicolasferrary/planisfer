module SearchesHelper
  def polyline_structure(round_trip_flight)
    if round_trip_flight.latitude_arrive == round_trip_flight.latitude_back
      polylines = [
        [
          {"lng": round_trip_flight.longitude_home, "lat": round_trip_flight.latitude_home, "strokeColor": "#0185b5"},
          {"lng": round_trip_flight.longitude_arrive, "lat": round_trip_flight.latitude_arrive}
        ],
      ]
    else
      polylines = [
        [
          {"lng": round_trip_flight.longitude_home, "lat": round_trip_flight.latitude_home, "strokeColor": "#0185b5"},
          {"lng": round_trip_flight.longitude_arrive, "lat": round_trip_flight.latitude_arrive}
        ],
        [
          {"lng": round_trip_flight.longitude_back, "lat": round_trip_flight.latitude_back, "strokeColor": "#E67E22"},
          {"lng": round_trip_flight.longitude_home, "lat": round_trip_flight.latitude_home}
        ]
      ]
    end
    return polylines.to_json
  end
end
