class LobbiesController < ApplicationController
  #### This skips authentication so that you can hit localhost:3000/lobbies and see the lobbies
  skip_before_action :authenticate_user!

  before_action :set_lobby, only: [:show, :edit, :update, :destroy]

  # GET /lobbies
  def index
    # Also gets the lobby's total player_count
    @lobbies = Lobby.includes(:user_lobbies).map do |lobby|
      {
        id: lobby.id,
        game: lobby.game,
        is_active: lobby.is_active,
        player_count: lobby.user_lobbies.count
      }
    end

    render json: @lobbies
  end

  # GET /lobbies/1
  def show
    render json: @lobby
  end

  # GET /lobbies/new
  def new
    @lobby = Lobby.new
  end

  # GET /lobbies/1/edit
  def edit
  end

  # POST /lobbies
  def create
    @lobby = Lobby.new(lobby_params)

    if @lobby.save
      redirect_to @lobby, notice: 'Lobby was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /lobbies/1
  def update
    if @lobby.update(lobby_params)
      redirect_to @lobby, notice: 'Lobby was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /lobbies/1
  def destroy
    @lobby.destroy
    redirect_to lobbies_url, notice: 'Lobby was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lobby
    @lobby = Lobby.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def lobby_params
    params.require(:lobby).permit(:game, :player_count, :is_active)
  end
end
