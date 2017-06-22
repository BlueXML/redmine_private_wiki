require File.expand_path('../../test_helper',__FILE__)

class WikiPagePatchTest < ActiveSupport::TestCase

	fixtures :projects, :wikis, :wiki_pages

	setup do
      @controller = WikiController.new

      @project = Project.find(1)  
      @project.enable_module! :wiki
      @wiki = @project.wiki
      @page = @wiki.find_page('Another_page')
      @page.private = true
      @page.save!
	end

	test 'has_private_parent_true' do
		#A page that has a private parent
     	@page = @wiki.find_page('Child_1')
		assert_equal true, @page.has_private_parent?
	end

	test 'has_private_parent_false' do
		#A page that doesn't have a private parent
		assert_equal true, !@page.has_private_parent?
	end

end