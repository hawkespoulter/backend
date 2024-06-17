class LobbiesController < ApplicationController
  #### This skips authentication so that you can hit localhost:3000/lobbies and see the lobbies
  skip_before_action :authenticate_user!

  before_action :set_lobby, only: [:show, :edit, :update, :destroy]

  # GET /lobbies
  def index
    # Also gets the lobby's total player_count
    @lobbies = Lobby.includes(user_lobbies: :user).order(:id).map do |lobby|
      lobby_data = {
        id: lobby.id,
        game: lobby.game,
        is_active: lobby.is_active,
        player_count: lobby.user_lobbies.count,
        owner: {
          id: lobby.owner_id,
          name: lobby.owner.name
        },
        joined: current_user.in_lobby?(lobby), # Tell the frontend if the current user is in the lobby or not
        players: lobby.user_lobbies.map do |user_lobby| # Get the list of players with their id, name, and number
          {
            id: user_lobby.user_id,
            name: user_lobby.user.name,
            player_number: user_lobby.player_number
          }
        end,
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
    # Check if user already owns a lobby
    if current_user.owns_lobby?
      redirect_to lobbies_path, alert: 'You cannot join a new lobby because you already own or are part of a lobby.'
      return
    end

    # Create a new lobby
    @lobby = Lobby.new(lobby_params)
  
    # Set the owner of the lobby
    @lobby.owner = current_user
  
    # Save the lobby first
    if @lobby.save
      # Set the player number to 1 for the owner
      @user_lobby = @lobby.user_lobbies.build(user: current_user, player_number: 1)
      
      if @user_lobby.save
        redirect_to @lobby, notice: 'Lobby was successfully created.'
      else
        @lobby.destroy
        render :new
      end
    else
      render :new
    end
  end

  # PATCH/PUT /lobbies/:id
  def update
    # Do we use this? Or do we just make custom defs like `def join` for lobby actions

    redirect_to @lobby, notice: 'Updated lobby.'
  end

  # POST /lobbies/:id/join
  def join
    # Check if the user has already joined a lobby (that they do not own)
    if current_user.in_any_lobby?
      redirect_to lobbies_path, alert: 'You cannot join a new lobby because you already own or are part of a lobby.'
      return
    end

    # Check if the current user is already in the lobby
    @lobby = Lobby.find(params[:id])
    if current_user.in_lobby?(@lobby)
      # If the current user is already in the lobby, tell in the frontend
      render json: @lobby, status: :ok
    else
      # If the current user is not in the lobby, add them to the lobby
      newPlayerNumber = @lobby.user_lobbies.count + 1 # Increment the current player count by 1 to get the proper player number
      @user_lobby = @lobby.user_lobbies.build(user: current_user, player_number: newPlayerNumber)

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
    # Only allow the lobby owner to delete the lobby
    if current_user.is_lobby_owner?(@lobby)
      @lobby = Lobby.find(params[:id])
      @lobby.destroy
      render json: { message: 'Lobby was successfully destroyed.' }, status: :ok
    else
      render json: { message: "User isn't the lobby owner" }, status: :error
    end
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
