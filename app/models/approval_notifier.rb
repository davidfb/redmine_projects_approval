class ApprovalNotifier < Mailer

  unloadable

  def waiting_for_approval(admin, project, asker)
    set_language_if_valid admin.language
    recipients   admin.mail
    subject      'Request for new project'
    content_type "multipart/alternative"
    body         :asker => asker, :project => project, :link => url_for(:controller => :admin, :action => :projects, :status => 2, :name => URI.escape(project.name))
  end

  def project_has_been_approved(user, project)
    set_language_if_valid user.language
    recipients   user.mail
    subject      'Accepted project notification'
    content_type "multipart/alternative"
    body         :project => project, :link => url_for(:controller => :projects, :action => :settings, :id => URI.escape(project.identifier))
  end

end
