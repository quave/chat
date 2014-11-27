class GamesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_game, except: [:index, :create, :new, :show]
  before_action :set_game_lists, only: [:show, :new, :update]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game
      .includes(:characters)
      .find(params[:id])
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # PUT /games/1/start
  def start
    @game.start_by current_user
    redirect_to @game
  end

  # PUT /games/1/stop
  def stop
    @game.stop_by current_user
    redirect_to @game
  end

  # POST /games
  # POST /games.json
  def creates
    @game = Game.new(game_params)
    @game.creator = current_user

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Ура! Игра создана!' }
        format.json { render action: 'show', status: :created, location: @game }
      else
        format.html { render action: 'new' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Ура! Игра обновлена!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game).permit(:name, :desc, :need_chars, :tags, :deny_empty_requests, :private)
    end
end
