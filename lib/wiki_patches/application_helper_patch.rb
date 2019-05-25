require_dependency 'application_helper'
module WikiPatches
    module ApplicationHelperPatch
        def self.included(base)
            base.class_eval do
              #Override application's method to not display hidden wikis or to display it with the PRIVATE flag
		def render_page_hierarchy(pages, node=nil, options={})
		    content = +''
		    if pages[node]
			    content << "<ul class=\"pages-hierarchy\">\n"
			    pages[node].each do |page|
				    if page.private and !User.current.allowed_to?(:view_privates_wiki, @project) then
					    next
				    end
				    content << "<li>"
				    if controller.controller_name == 'wiki' && controller.action_name == 'export'
					    href = "##{page.title}"
				    else
					    href = {:controller => 'wiki', :action => 'show', :project_id => page.project, :id => page.title, :version => nil}
				    end
				    content << link_to(h(page.pretty_title), href,
						       :title => (options[:timestamp] && page.updated_on ? l(:label_updated_time, distance_of_time_in_words(Time.now, page.updated_on)) : nil))
				    if page.private then
				            content << "&nbsp;&nbsp;&nbsp;&nbsp;<span class=\"private_wiki_flag\" style=\"display:inline-block;\">" + l(:private_flag) + "</span>"
				    end
				    content << "\n" + render_page_hierarchy(pages, page.id, options) if pages[page.id]
				    content << "</li>\n"
			    end
			    content << "</ul>\n"
		    end
		    content.html_safe
		end
            end
        end
    end
end

