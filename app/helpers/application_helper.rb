module ApplicationHelper

	def user_image_url(user)
    # byebug
    if user.avatar.url.nil?
      "thumb_default_pic.jpg"
    else
      user.avatar.url(:thumb)
    end

end
end
