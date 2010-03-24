class ApprovalNotifier < Mailer

  def waiting_for_approval(admin, project)
    set_language_if_valid admin.language
    recipients   admin.mail
    subject      'Request for new project'
    body         :project => project, :link => url_for(:controller => :admin, :action => :projects, :status => 2, :name => URI.escape(project.name))
  end

  def project_has_been_approved(user, project)
    set_language_if_valid user.language
    recipients   user.mail
    subject      'Accepted project notification'
    body         :project => project, :link => url_for(:controller => :projects, :action => :settings, :id => URI.escape(project.identifier))
  end

end
