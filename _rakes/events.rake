require 'json'

source_dir = CONFIG.source_dir
event_dir  = CONFIG.event_dir
data_dir   = CONFIG.data_dir

# usage rake setup_events
desc "Setup Event functionality"
task :setup_events do
  cp_r "#{starter_dir}/events/.", "#{source_dir}/_layouts/"
  mkdir_p data_dir
  cp_r "#{starter_dir}/data/.", "#{data_dir}"
  puts "\nEvents setup complete!\n"
end

# usage rake new_event
desc "Create a new Event page in #{source_dir}/#{event_dir}/(state)/(city)/(name)"
task :new_event, :event do |t, args|
  raise "\n####\nYou haven't set anything up yet.\nFirst run `rake setup` to set up Octostrap.\n####" unless File.directory?(source_dir)

  if args.event
    event = args.event
  else
    event = {'contact'=>{}, 'location'=>{'state'=>{}}}
  end
  # shortcuts
  contact = event['contact']
  loc = event['location']

  # get user input
  unless args.event

    # basic info
    puts "First, the basics..."
    puts "NOTE: Just hit enter if you don't know some of this information"
    event['title']  = get_stdin("Enter a title for your event: ")
    event['date']   = get_stdin("Enter a date for your event (in YYYY-MM-DD format): ")
    event['time']   = get_stdin("Enter the time your event is taking place: ")
    loc['name']     = get_stdin("Enter the name of the location where this event is taking place: ")
    loc['state']    = get_stdin("Enter the state abbreviation where this event is taking place: ")
    loc['city']     = get_stdin("Enter the city where this event is taking place: ")

    raise "\n####\nYou can't create an event without a city, state, and date\n####" if [loc['city'], loc['state'], loc['name'], event['date']].any? { |i| i.nil? || i.empty? }
    puts "\nOkay, got it. Starting a new event for #{loc['city']}, #{loc['state'].upcase}\n"

    # map info
    if ask("\nDo you want to have a map of the event location available?", ['y', 'n']) == 'y'
      if ask("Do you have the latitude and longitude available?", ['y', 'n']) == 'y'
        loc['lat']  = get_stdin("Enter latitude: ")
        loc['long'] = get_stdin("Enter longitude: ")
      else
        puts "Okay, but I can't generate maps without lat/long values. Moving on.\n"
      end
      if ask("Do you have the street address available?", ['y', 'n']) == 'y'
        loc['address'] = get_stdin("Enter the full street address (exclude city/state/zip): ")
        loc['zip']     = get_stdin("Enter the zip code: ")
      else
        puts "Okay, but people won't be able to find the event without an address. Moving on.\n"
      end
    end

    puts "\nOkay, got it. The event will be at #{loc['address']} #{loc['city']}, #{loc['state'].upcase} #{loc['zip']}"

    # contact info
    if ask("\nDo you have contact information available?", ['y', 'n']) == 'y'
      puts "NOTE: Just hit enter if you don't know some of this information"
      contact['name']     = get_stdin("Enter a contact name: ")
      contact['email']    = get_stdin("Enter a contact email: ")
      contact['facebook'] = get_stdin("Enter a Facebook page address: ")
      contact['twitter']  = get_stdin("Enter a Twitter address: ")
    else
      puts "Okay, but people might want to contact someone to find out more details. Moving on.\n"
    end

  end

  # just in case someone calls with non-hash :event param
  raise "\n####\nInvalid event. Must be a Hash.\n####" unless event.is_a?(Hash)

  # verfiy details correct
  puts "\nOkay, got it. Here are the new event details for you to verify:\n\n"
  puts "Title: #{event['title']}"
  puts "Date: #{event['date']}"
  puts "Time: #{event['time']}"
  puts "Location Info:"
  loc.each do |k,v|
    puts "  #{k}: \"#{v}\""
  end
  puts "Contact Info:"
  contact.each do |k,v|
    puts "  #{k}: \"#{v}\""
  end

  unless ask("\nCreate this event?", ['y', 'n']) == 'n'
    puts "\nWriting event file ...\n"
    dir = "#{source_dir}/#{event_dir}/#{loc['state'].downcase}/#{loc['city'].to_url}/#{loc['name'].to_url}"
    file = "#{dir}/index.md"
    mkdir_p dir
    if File.exist?(file)
      abort("rake aborted!") if ask("#{file} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
    end
    puts "Creating new event page: #{file}"
    open(file, 'w') do |page|
      page.puts "---"
      page.puts "layout: event"
      page.puts "title: \"#{event['title']}\""
      page.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
      page.puts "event:"
      page.puts "  title: \"#{event['title']}\""
      page.puts "  date: \"#{event['date']}\""
      page.puts "  time: \"#{event['time']}\""
      page.puts "  description:"
      page.puts "  contact:"
      contact.each do |k,v|
        page.puts "    #{k}: \"#{v}\""
      end
      page.puts "location:"
      loc.each do |k,v|
        page.puts "  #{k}: \"#{v}\""
      end
      page.puts "---"
    end
  end
end

# usage rake load_events
desc "Load events from JSON file"
task :load_events do
  puts "Parsing JSON..."
  events_data = JSON.parse(IO.read("#{data_dir}/events.json"))
  events = []
  puts "Processing #{events_data['events'].length} events..."

  # process json data
  events_data['events'].each_with_index do |e, i|
    puts "Building event #{i}..."
    event = {}
    e['event'].each do |item|
      key = item['name']
      event[key] = item['value'] unless item['value'].is_a?(Array)
      if item['value'].is_a?(Array)
        key = item['name']
        event[key] = {}
        item['value'].each do |item|
          key2 = item['name']
          event[key][key2] = item['value']
        end
      end
    end
    events << event
  end

  # build pages
  events.each_with_index do |event, i|
    case i
    when 0
      Rake::Task["new_event"].invoke(event)
    else
      Rake::Task["new_event"].reenable
      Rake::Task["new_event"].invoke(event)
    end
  end
end
