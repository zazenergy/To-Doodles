require 'addressable/uri'
require 'json'
require 'rest_client'
HOST = "localhost:3000"

require 'rubygems'
require 'pry'
require 'highline/import'

class HighLine
  # ANSI escape code to clear the screen.
  # http://en.wikipedia.org/wiki/ANSI_escape_code#CSI_codes
  CLEAR_SCREEN = "\e[2J"
end

def get(path)
	uri = Addressable::URI.new(:scheme => 'http', :host => HOST, :path => path)
	response = RestClient.get(uri.to_s)
    return JSON.parse(response)
end
def post(path, data)
	uri = Addressable::URI.new(:scheme => 'http', :host => HOST, :path => path)
	response = RestClient.post(uri.to_s, JSON.dump(data), :content_type => :json, :accept => :json)
	return JSON.parse(response)
end

def delete(path)
  uri = Addressable::URI.new(:scheme => 'http', :host => HOST, :path => path)
  response = RestClient.delete(uri.to_s)
end

def dolphins
	dolphin = <<-EOF
	                                 __ 
                               _.-~  )
                    _..--~~~~,'   ,-/     _
                 .-'. . . .'   ,-','    ,' )
               ,'. . . _   ,--~,-'__..-'  ,'
             ,'. . .  (@)' ---~~~~      ,'
            /. . . . '~~             ,-'
           /. . . . .             ,-'
          ; . . . .  - .        ,'
         : . . . .       _     /
        . . . . .          `-.:
       . . . ./  - .          )
      .  . . |  _____..---.._/ _____
~---~~~~----~~~~             ~~
	EOF
	say(dolphin)
end
def main_menu
  say(HighLine::CLEAR_SCREEN)
  dolphins
	say("Welcome to the Toodles API.")

	choose do |menu|
		menu.prompt = "> "

		menu.choice('Create a list') do create_list end
		menu.choice('Exit the program') do exit end
		list_names.each do |name|
			 menu.choice("View list #{name}") do display_list(name) end
		end
	end
end

def create_list
  name = ask("What would you like to call your list: ")
  begin
    say("Creating list...")
    post('/lists.json', {:list => {:name => name}})
  rescue RestClient::Found
  end
  say("  ... Done!")
  sleep(1)
  main_menu 
end

def delete_task(id)
  begin
   delete("/tasks/#{id}.json")
  rescue RestClient::Found
  end
end

def delete_task_from(list)
  choose do |menu|
    menu.prompt = 'Which task shall we delete?'
    menu.index_suffix = ') '
    list['tasks'].each do |task|
      menu.choice(task['description']) do delete_task(task['id']) end
    end
  end
end

def display_list(list_name)
	# Fetch all lists from API (including ids and names)
	# Figure out id for given name
	# Display list (based on id) and tasks
    list_id = lists.select { |l| l["name"] == list_name }.first["id"]
    list = get("/lists/#{list_id}.json")
    tasks = list['tasks'].map { |t| t['description'] }
    
    say("For list #{list_name}, there are #{list['tasks'].length} tasks. They are:")
    say(tasks.join("\n"))

    choose do |menu|
      menu.index_suffix = ') '
      # Add task
      menu.choice('Add a task') do add_task(list_id) end
      # Delete task
      menu.choice('Delete task') do delete_task_from(list) end
      # Delete list
      menu.choice('Delete this list') do delete_list(list_id) end
      # Main menu
      menu.choice('Back to main menu')
    end
    main_menu
end
def add_task(list_id)
	description = ask("Task description: ")
	begin
		post('/tasks.json', {:task => { :description => description, :list_id => list_id }})
	rescue RestClient::Found 
	end
end

def delete_list(list_id)
  begin
    delete("/lists/#{list_id}")
  rescue  RestClient::Found
  end
  main_menu
end

# Returns an Array of Hashes representing each list
def lists
	get('/lists.json')
end

# Returns an Array of names for each list.
def list_names
	lists.map {|list| list["name"]} 
end

dolphins
main_menu
