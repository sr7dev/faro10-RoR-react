class MoodsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  # GET /moods
  # GET /moods.json
  def index
    @moods = Mood.all
  end

  # GET /moods/1
  # GET /moods/1.json
  def show
    @mood = Mood.find(params[current_user])
  end

  # GET /moods/new
  def new
    @mood = Mood.new(params[current_user])
  end

  # GET /moods/1/edit
  def edit
    @mood = Mood.edit(params[current_user])
  end

  # POST /moods
  # POST /moods.json
  def create
    @mood = Mood.new(mood_params)
    @mood.user_id = current_user
    @mood.save
    flash[:success] = "Mood Updated!"
    redirect_to root_url
  end

  # PATCH/PUT /moods/1
  # PATCH/PUT /moods/1.json
  def update
  end

  # DELETE /moods/1
  # DELETE /moods/1.json
  def destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_mood
    @mood = Mood.find(params[current_user])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def mood_params
    params.require(:mood).permit(:user_id, :mood)
  end
end
