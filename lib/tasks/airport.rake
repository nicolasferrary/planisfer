# desc 'building airport_listing with autocomplete'

# task buiding_listing: :environment do
#     start_time = Time.now
#     airport_listing = []

#     Airport.all.each |airport| do
#       airport_listing << airport.name
#     end

#     print "> "
#     print airport_listing

#     end_time = Time.now
#     duration = (start_time - end_time) / 1.minute
#     print "Task finished at #{end_time} and last #{duration} minutes."
# end
