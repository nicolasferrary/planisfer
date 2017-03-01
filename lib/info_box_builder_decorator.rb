# class InfoBoxBuilder extends Gmaps.Google.Builders.Marker # inherit from base builder
#   # override method
#   create_infowindow: ->
#     return null unless _.isString @args.infowindow

#     boxText = document.createElement("div")
#     boxText.setAttribute('class', 'marker_container') #to customize
#     boxText.innerHTML = @args.infowindow
#     @infowindow = new InfoBox(@infobox(boxText))

#     # add @bind_infowindow() for < 2.1

#   infobox: (boxText)->
#     content: boxText
#     pixelOffset: new google.maps.Size(-140, 0)
#     boxStyle:
#       width: "280px"

# handler = Gmaps.build 'Google', { builders: { Marker: InfoBoxBuilder} }

