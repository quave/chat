class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :set_game

  # GET /rooms/1
  # GET /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)
    @room.game_id = @game.id

    respond_to do |format|
      if @room.save
        format.html { redirect_to @game, notice: 'Ура! Комната создана!' }
        format.json { render action: 'show', status: :created, location: @room }
      else
        format.html { render action: 'new' }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @game, notice: 'Ура! Комната обновлена!' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to @game }
      format.json { head :no_content }
    end
  end

  # PUT /game/1/room/1/up
  def up
    room = Room.find(params[:id])
    prev_room = Room.find(:first, :conditions => {:game_id => params[:game_id], :order => room.order - 1})

    if prev_room.nil?
      flash[:error] = "Не могу двигать вверх."
      redirect_to game_path(params[:game_id]) 
      return
    end

    room.order -= 1
    room.save

    prev_room.order += 1
    prev_room.save

    redirect_to game_path(params[:game_id])
  end

  # PUT /game/1/room/1/down
  def down
    room = Room.find(params[:id])
    next_room = Room.find(:first, :conditions => {:game_id => params[:game_id], :order => room.order + 1})

    if next_room.nil?
      flash[:error] = "Не могу двигать вниз."
      redirect_to game_path(params[:game_id]) 
      return
    end

    room.order += 1
    room.save

    next_room.order -= 1
    next_room.save

    redirect_to game_path(params[:game_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    def set_game
      @game = Game.find params[:game_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name)
    end
end
