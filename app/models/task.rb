class Task < ActiveRecord::Base
 	attr_accessible :list_id, :description
	belongs_to :list	
end
