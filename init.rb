require 'redmine'


Redmine::Plugin.register :redmine_projects_approval do
  name 'Redmine Projects Approval plugin'
  author 'David Fuentes Baldomir'
  description 'This plugin adds a mandatory approval step after all projects creation. Admins will have to approve each and every single project before they can be seen by any user.'
  version '0.0.2'
end


# Approval behaviour is added to all projects.

Project.class_eval { include ActiveRecord::ProjectApproval }


# Creation behaviour is modified on Projects Controller. User will be redirected to 'index' action upon creation and the
# notice message will be updated to reflect the need of approval.

ProjectsController.class_eval do
  after_filter(:only => [ :add, :create ]) do |controller|
    project = controller.instance_variable_get('@project')
    if controller.request.post? and project and project.errors.empty? and project.status == Project::STATUS_WAITING_FOR_APPROVAL
      flash[:notice] = " #{I18n.t('projects_approval.creation_flash_message')}"
    end
  end

end
