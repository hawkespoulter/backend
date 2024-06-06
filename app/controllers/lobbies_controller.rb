class LobbiesController < ApplicationController
  #### This skips authentication so that you can hit localhost:3000/lobbies and see the lobbies
  skip_before_action :authenticate_user!

  before_action :set_lobby, only: [:show, :edit, :update, :destroy]

  # GET /lobbies
  def index
    # Also gets the lobby's total player_count
    @lobbies = Lobby.includes(:user_lobbies).map do |lobby|
      lobby_data = {
        id: lobby.id,
        game: lobby.game,
        is_active: lobby.is_active,
        player_count: lobby.user_lobbies.count,
        owner: {
          id: lobby.owner_id,
          name: lobby.owner.name
        },
        joined: current_user.in_lobby?(lobby) # Tell the frontend if the current user is in the lobby or not
      }

      lobby_data
    end

    render json: @lobbies
  end

  # GET /lobbies/:id
  def show
    render json: @lobby
  end

  # GET /lobbies/new
  def new
    @lobby = Lobby.new
  end

  # GET /lobbies/:id/edit
  def edit
  end

  # POST /lobbies
  def create
    @lobby = Lobby.new(lobby_params)
    
    # Set the owner of the lobby
    @lobby.owner = current_user

    # Associate the current user with the lobby
    @user_lobby = @lobby.user_lobbies.build(user: current_user)

    if @lobby.save && @user_lobby.save
      redirect_to @lobby, notice: 'Lobby was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /lobbies/:id
  def update
    # Check if the current user is already in the lobby
    if current_user.in_lobby?(@lobby)
      # If the current user is already in the lobby, tell in the frontend
      render json: @lobby, status: :ok
    else
      # If the current user is not in the lobby, add them to the lobby
      @user_lobby = @lobby.user_lobbies.build(user: current_user)

      if @user_lobby.save
        redirect_to @lobby, notice: 'Joined lobby.'
      else
        render :edit
      end
    end
  end

  # POST /lobbies/:id/leave
  def leave
    @lobby = Lobby.find(params[:id])
  
    # Check if the current user is in the lobby
    if current_user.in_lobby?(@lobby)
      # Find and destroy the user_lobby association
      user_lobby = @lobby.user_lobbies.find_by(user: current_user)
      user_lobby.destroy
  
      render json: { message: 'You have left the lobby successfully' }, status: :ok
    else
      render json: { error: 'You are not in this lobby' }, status: :unprocessable_entity
    end
  end
  

  # DELETE /lobbies/:id
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
    params.require(:lobby).permit(:game, :is_active)
  end
end
