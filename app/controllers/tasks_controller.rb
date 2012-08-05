class TasksController < ApplicationController
 	respond_to :html, :json 

  def index
    @tasks = Task.all
    respond_with(@tasks)
  end

  def create
    #binding.pry
    @task = Task.create(params[:task])
    redirect_to list_path(params[:task][:list_id])
  end

  def destroy
    Task.destroy(params[:id])
    redirect_to tasks_path
  end

  def complete 
    # For each task that is complete, delete it from the Tasks Table.
    for task in params[:task_ids]		
      Task.destroy(task)
    end
    # Redirect back to the List show view
    list_id = params[:list_id].to_i
    redirect_to list_path(list_id)
  end
end
