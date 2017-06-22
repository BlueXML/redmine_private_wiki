module WikiPatches
	class WikiPatchesHook < Redmine::Hook::ViewListener
		#Add the content of private_wiki_management_views/_body_bottom.html.erb to general layout
		render_on :view_layouts_base_body_bottom, :partial => 'private_wiki_management_views/body_bottom'
		render_on :view_layouts_base_html_head, :partial => 'private_wiki_management_views/html_head'
	end
end