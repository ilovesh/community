# Don't let Rails add a utf8=✓ param to GET forms.
# See http://stackoverflow.com/questions/3222013/what-is-the-snowman-param-in-rails-3-forms-for for details.
module ActionView::Helpers::FormTagHelper
private

  def extra_tags_for_form_with_utf8_param_excluded_from_gets(html_options)
    old = extra_tags_for_form_without_utf8_param_excluded_from_gets(html_options)
    non_get = old.include?('"_method"') || old.include?('"'+request_forgery_protection_token.to_s+'"')
    if non_get
      old
    else
      old.sub(/<[^>]+name="utf8"[^>]+"&#x2713;"[^>]*>/, '').html_safe
    end
  end

  alias_method_chain :extra_tags_for_form, :utf8_param_excluded_from_gets

end