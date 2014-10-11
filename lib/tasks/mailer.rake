namespace :mailer do
  desc 'Sends unread emails at the moment of call to users'
  GameUnread = Struct.new(:game, :unread_count)
  task send_unread: :environment do
    active_games = Game.active

    digest_list = {}

    active_games.each do |g|
      users = g.characters.map(&:user)

      users.each do |u|
        digest_list[u] ||= []
        digest_list[u] << GameUnread.new(g, g.unread_messages_count(u))
      end
    end

    digest_list.each do |u, d|
      UnreadMailer.unread_digest u, d
    end
  end

end
