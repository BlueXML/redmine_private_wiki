module WikiPatches
	module WikiControllerPatch
		def self.included(base)
			base.send(:include, InstanceMethods)
     		base.class_eval do
                unloadable
                #Test :valide before :show action on wiki_controller
        		before_filter :validate, :only => [:show,:edit,:rename, :protect, :history, :diff, :annotate, :add_attachment, :destroy]
        	end
        end

        module InstanceMethods
            def change_privacy
                find_existing_page
                #":private" attribute of wiki page is set to :private parameter
                @page.update_attribute :private, params[:private]

                #Then redirection to the previous page
                redirect_to project_wiki_page_path(@project, @page.title)
            end

        	def validate
                #If page is private and user not allowed to see it, then deny_access
         		deny_access and return if @page.private? and !User.current.allowed_to?(:view_privates_wiki, @project)
        	end
        end
    end
end