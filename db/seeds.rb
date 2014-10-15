# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(name: 'Vlad', email: 'vlad@admin.ru', password: '123456789', send_unread: false, confirmed_at: DateTime.now)
desc = 'This file should contain all the record creation needed to seed the database with its default values. The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).'
game = Game.create(name: 'Дева розы', desc: desc, creator_id: user.id, need_chars: 4, tags: 'n00bs, d&d4, evil master')

user = User.create(name: 'Vlad2', email: 'vlad2@admin.ru', password: '123456789', send_unread: false, confirmed_at: DateTime.now)
Game.create(name: 'Новые горизонты', desc: desc, creator_id: user.id, need_chars: 5, tags: 'evil master, hardcore, massacre, d&d3.5')

user = User.create(name: 'Waron', email: 'v1@v.ru', password: '123456789', send_unread: false, confirmed_at: DateTime.now)
Character.create name: 'Салесити', profile: user, game: game, status: Character::ACTIVE

user = User.create(name: 'kicjakun', email: 'v2@v.ru', password: '123456789', send_unread: false, confirmed_at: DateTime.now)
Character.create name: 'Иллт', profile: user, game: game, status: Character::ACTIVE

user = User.create(name: 'Fovire', email: 'v3@v.ru', password: '123456789', send_unread: false, confirmed_at: DateTime.now)
Character.create name: 'Масторкавен', profile: user, game: game, status: Character::ACTIVE

user = User.create(name: 'Entreria', email: 'v4@v.ru', password: '123456789', send_unread: false, confirmed_at: DateTime.now)
Character.create name: 'Байкл Мэй', profile: user, game: game, status: Character::ACTIVE

