class ApprovalNotifier < Mailer

  unloadable

  template_root = File.join(File.dirname(__FILE__), '..', 'views')

  def waiting_for_approval(admin, project, asker)
    set_language_if_valid admin.language
    @asker=asker
    @project=project
    @link=url_for(:controller => :admin, :action => :projects, :status => 9, :name => URI.escape(project.name))
    mail(to: admin.mail,
         subject: 'Request for new project',
         template_path: 'approval_notifier',
         template_name: 'waiting_for_approval')
  end

  def project_has_been_approved(user, project)
    set_language_if_valid user.language
    @project=project
    @link=url_for(:controller => :projects, :action => :settings, :id => URI.escape(project.identifier))
    mail(to: user.mail,
         subject: 'Accepted project notification')
  end

end
