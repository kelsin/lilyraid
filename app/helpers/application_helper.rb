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
end
