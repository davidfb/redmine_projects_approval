class ApprovalNotifier < Mailer

  unloadable

  template_root = File.join(File.dirname(__FILE__), '..', 'views')

  def waiting_for_approval(admin, project, asker)
    set_language_if_valid admin.language
    recipients   admin.mail
    subject      'Request for new project'
    content_type "multipart/alternative"
    body         :asker => asker, :project => project, :link => url_for(:controller => :admin, :action => :projects, :status => 2, :name => URI.escape(project.name))
    render_multipart('waiting_for_approval', body)
  end

  def project_has_been_approved(user, project)
    set_language_if_valid user.language
    recipients   user.mail
    subject      'Accepted project notification'
    content_type "multipart/alternative"
    body         :project => project, :link => url_for(:controller => :projects, :action => :settings, :id => URI.escape(project.identifier))
    render_multipart('project_has_been_approved', body)
  end

end
