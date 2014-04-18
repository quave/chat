module GamesHelper
  def can_edit_game?(game)
    user_signed_in? && game.creator_id == current_user.id
  end
end
