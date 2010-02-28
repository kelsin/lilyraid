module AccountsHelper
  def lj_link(account)
    "http://#{account.lj_account}.livejournal.com/"
  end
end
