Toodles::Application.routes.draw do
	resources :lists 
	
	resources :tasks do
		collection do
			put :complete
		end
	end
end
