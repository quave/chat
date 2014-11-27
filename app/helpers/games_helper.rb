module GamesHelper
  def can_edit_game?(game)
    user_signed_in? && game.creator_id == current_user.id
  end

  def get_status_class(status)
    case status
      when Game::STARTED
        'success'
      when Game::OVER
        'danger'
      else
        'primary'
    end
  end
end
