require 'redmine'


Redmine::Plugin.register :redmine_projects_approval do
  name 'Redmine Projects Approval plugin'
  author 'David Fuentes Baldomir'
  description 'This plugin adds a mandatory approval step after all projects creation. Admins will have to approve each and every single project before they can be seen by any user.'
  version '0.0.1'
end


# The new ActionMailer view path is added to the list of paths.

ActionMailer::Base.view_paths << File.join(File.dirname(__FILE__), 'app', 'views')


# Approval behaviour is added to all projects.

Project.class_eval { include ActiveRecord::ProjectApproval }


# Creation behaviour is modified on Projects Controller. User will be redirected to 'index' action upon creation and the
# notice message will be updated to reflect the need of approval.

ProjectsController.class_eval do

  after_filter(:only => :add) do |c|
    project = c.instance_variable_get('@project')
    if c.request.post? and project and project.errors.empty? and project.status == Project::STATUS_WAITING_FOR_APPROVAL
      c.send(:flash)[:notice] += " #{I18n.t('projects_approval.creation_flash_message')}"
      c.instance_variable_set('@performed_redirect', false)
      c.send(:redirect_to, {:action => :index})
    end
  end

end
