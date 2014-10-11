class UnreadMailer < ActionMailer::Base
  default from: 'info@roleplayground.ru'

  def unread_digest(user, digest)
    @user = user
    @digest = digest
    mail(to: @user.email, subject: 'Новые сообщения ждут твоего внимания!')
  end
end
