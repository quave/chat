namespace :mailer do
  desc 'Sends unread emails at the moment of call to users'
  GameUnread = Struct.new(:game, :unread_count)

  def deliver_digest(user, digest)
    UnreadMailer.unread_digest(user, digest).deliver if user.send_unread
  rescue Exception => e
    puts e.inspect
  end

  task send_unread: :environment do
    active_games = Game.active

    digest_list = {}

    active_games.each do |g|
      users = g.characters.map(&:profiles)

      users.each do |u|
        digest_list[u] ||= []
        digest_list[u] << GameUnread.new(g, g.unread_messages_count(u))
      end
    end

    digest_list.each {|u, d| deliver_digest(u,d)}
  end

end
