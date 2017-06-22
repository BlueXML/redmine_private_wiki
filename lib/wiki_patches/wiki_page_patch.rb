module WikiPatches
    module WikiPagePatch
        def self.included(base)
            base.send(:include, InstanceMethods)
            base.class_eval do
                unloadable
            end
        end

    module InstanceMethods
        #Check if the wiki page as any private parent
        def has_private_parent?()
                @res = self.parent_title
                while @res != nil
                    if self.project.wiki.find_page(@res).private?
                        return true
                    else
                        @res = self.project.wiki.find_page(@res).parent_title
                    end
                end
                return false;
            end
        end
    end
end






            
