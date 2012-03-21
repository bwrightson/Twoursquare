class UsersController < ApplicationController
  def connect
    auth = request.env["omniauth.auth"]
    if ! User.find_by_provider_and_uid(auth["provider"], auth["uid"])
      user = User.create(auth)
    end
    redirect_to :action => "complete"
  end
  def complete
  end
end
