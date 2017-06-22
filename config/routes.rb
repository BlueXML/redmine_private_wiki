# Plugin's routes
RedmineApp::Application.routes.draw do
	#Allow utilisation of action 'change_privacy' in links (set route to wiki method)
	match 'projects/:project_id/wiki/:id/change_privacy/:private', :controller => 'wiki', :action => 'change_privacy', :via => [:post]
end
