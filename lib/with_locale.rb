module WithLocale

  include Redmine::I18n

  def self.do(locale)
    old_locale = I18n.locale
    set_language_if_valid(locale)
    result = yield
    set_language_if_valid(old_locale)
    result
  end

end
