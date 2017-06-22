require_dependency 'application_helper'
module WikiPatches
    module ApplicationHelperPatch
        def self.included(base)
            base.class_eval do

              #Override application's method to not display hidden wikis or to display it with the PRIVATE flag
            	def render_page_hierarchy_with_wiki_hidding(pages, node=nil, options={})
                    content = ''
                    if pages[node]
                      content << "<ul class=\"pages-hierarchy\">\n"
                      pages[node].each do |page|
                        if !page.private? then
                            content << "<li>"
                            content << link_to(h(page.pretty_title), {:controller => 'wiki', :action => 'show', :project_id => page.project, :id => page.title, :version => nil},
                                               :title => (options[:timestamp] && page.updated_on ? l(:label_updated_time, distance_of_time_in_words(Time.now, page.updated_on)) : nil))
                            content << "\n" + render_page_hierarchy(pages, page.id, options) if pages[page.id]
                            content << "</li>\n"
                        elsif User.current.allowed_to?(:view_privates_wiki, @project) then
                            content << "<li>"
                            content << link_to(h(page.pretty_title), {:controller => 'wiki', :action => 'show', :project_id => page.project, :id => page.title, :version => nil},
                                               :title => (options[:timestamp] && page.updated_on ? l(:label_updated_time, distance_of_time_in_words(Time.now, page.updated_on)) : nil))
                            content << "&nbsp;&nbsp;&nbsp;&nbsp;<span class='private_wiki_flag' style='display:inline-block;''>" + l(:private_flag) + " </span>"
                            content << "\n" + render_page_hierarchy(pages, page.id, options) if pages[page.id]
                            content << "</li>\n"
                        end
                      end
                      content << "</ul>\n"
                    end
                    content.html_safe
                  end

                alias_method_chain :render_page_hierarchy, :wiki_hidding

            end
        end
    end
end