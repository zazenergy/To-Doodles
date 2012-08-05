class ListsController < ApplicationController
	respond_to :html, :json

	def index
		@lists = List.all
		respond_with(@lists)
	end

	def show
		# If the request is a normal html request
		# render the List in the view as usual.
		#
		# If the request is a json request
		# bundle up all the tasks for the List with the list
		# and send that back to the requester.

		# Rails offers a request object that represents the
		# request received by the action method.
		#
		# This objects exposes useful things such as the 
		# response type requested, i.e html, json, etc. 

		@list = List.find(params[:id])	
		@task = Task.new
	    @task.list_id = @list.id

		#respond_with(@list)

		# We need to include the tasks data also, not just the list 
		# We get all the task for this list, and then put them all together
		# in a container along with the list itself.  Then send 
		# that back. 
		
		#Want list items as an array
		#Want list name as a hash
		#Contain them all in a hash
		
		all_tasks = @list.tasks
		respond_with ({:list => @list, :tasks => all_tasks})
	end

	def new
		@list = List.new
	end

	def create
		# When this action is called, routes gives us
		# the parameters needed to create a new list
		#
		# save the list here	

		# make object piece by piece
		# @list = List.new
		# @list.name = params["list"]["name"]
		#
		#
		# OR  all at the same time
		# 
		# @list = List.new(params[:list])
		# 
		# To see what params have been passed use "puts params"
		
		@list = List.new(params[:list])
		@list.save
	
		respond_with @list
	end	

	def destroy 
		# Get the thing you want to destroy first
		@list = List.find(params[:id])
		@list.destroy	

		# notice the path is plural
	
		#redirect_to lists_path
		respond_with @list, :location => lists_path
	end

end
