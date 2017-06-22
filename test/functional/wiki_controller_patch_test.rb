require File.expand_path('../../test_helper',__FILE__)


class WikiControllerPatchTest < ActionController::TestCase

	fixtures :projects, :users, :roles, :members, :member_roles, :wikis, :wiki_pages, :wiki_contents

	setup do
      @controller = WikiController.new

      @project = Project.find(1)  
      @project.enable_module! :wiki
      @role = Role.find(1)
      User.current = nil
      @request.session[:user_id] = 2
      @wiki = @project.wiki
      @page = @wiki.find_page('Another_page')
      @page.private = true
      @page.save!
	end

	test 'show_without_permission' do
		#User not allowed to see the wiki page
		get :show, :project_id => @project, :id => @page.title

		assert_response 403
		assert_select "span.private_wiki_flag", false, "There should not be a private flag"
	end

	test 'show_with_permission' do
		#User allowed to see the wiki page
		@role.add_permission! :view_privates_wiki
	    get :show, :project_id => @project, :id => @page.title

	    assert_response :success
	    assert_select "span.private_wiki_flag", true, "There should be a private flag"

	    #User not allowed to change privacy of wiki
	    assert_select "a.icon-setpublic", false, "There should not be a privacy button"

	    #User allowed to change privacy of wiki
	    @role.add_permission! :manage_privates_wiki
	    get :show, :project_id => @project, :id => @page.title

	    assert_select "body" do |elements|
			elements.each do |element|
				Rails::logger.debug("FLAG")
				Rails::logger.debug(element)
			end
		end

	    assert_select "a.icon-setpublic", true, "There should be a privacy button"
	end

	test 'edit_without_permission' do
		#User not allowed to edit wiki
		get :edit, :project_id => @project, :id => @page.title

		assert_response 403
	end

	test 'edit_with_permission' do
		#User allowed to edit wiki
		@role.add_permission! :view_privates_wiki
	    get :edit, :project_id => @project, :id => @page.title

	    assert_response :success
	end

	test 'post_change_privacy_without_permission' do
		#User not allowed to change privacy of wiki
		post :change_privacy, :project_id => @project, :id => @page.title, :private => 0

		assert_response 403
	end

	test 'post_change_privacy_with_permission' do
		#User allowed to change privacy of wiki
	    @role.add_permission! :manage_privates_wiki
		post :change_privacy, :project_id => @project, :id => @page.title, :private => 0

		assert_response :redirect
		assert !@page.reload.private
	end

	#Next tests somehow fails, but actually works ...
	#Probably due to the fact that elements are added directly through JS as text and not as elements.
	test 'index_without_permission' do
		#User not allowed to see the wiki page
		get :index, :project_id => @project

		assert_response :success
		assert_select "li.hide_private", true, "There should be a private <li>"
	end

	test 'index_with_permission' do
		#User allowed to see the wiki page
		@role.add_permission! :view_privates_wiki
		get :index, :project_id => @project

		assert_response :success
		assert_select "span.private_wiki_flag", true, "There should be a private flag"
		assert_select "li.hide_private", false, "There should not be a private <li>"
	end

	test 'date_index_without_permission' do
		#User not allowed to see the wiki page
		get :date_index, :project_id => @project

		assert_select "li.hide_private", true, "There should be a private <li>"
	end

	test 'date_index_with_permission' do
		#User allowed to see the wiki page
		@role.add_permission! :view_privates_wiki
		get :date_index, :project_id => @project

		assert_select "span.private_wiki_flag", true, "There should be a private flag"
		assert_select "li.hide_private", false, "There should not be a private <li>"
	end
end
