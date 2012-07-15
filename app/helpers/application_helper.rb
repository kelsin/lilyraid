module ApplicationHelper
  def admin?(raid = nil)
    raid ? @current_account.can_edit?(raid) : @current_account.admin?
  end

  def current_account_path
    account_path(@current_account)
  end

  def logged_in?
    !!@current_account
  end

  def errors_for(object)
    if object.respond_to?(:errors) and object.errors.respond_to?(:full_messages) and !object.errors.full_messages.empty?
      content_tag(:div, :class => 'errors') do
        content_tag(:ul) do
          object.errors.full_messages.inject('') do |html, error|
            html += content_tag(:li, error)
          end.html_safe
        end
      end
    end
  end
end
