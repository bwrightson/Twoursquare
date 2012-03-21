class User < ActiveRecord::Base
  def self.create(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["first_name"] + ' ' + auth["info"]["last_name"]
      user.phone = auth["extra"]["raw_info"]["contact"]["phone"]
      user.token = auth["credentials"]["token"]
    end
  end
end
