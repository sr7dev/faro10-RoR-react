class ActivityLevelsController < ApplicationController
  before_action :set_activity_level, only: [:show, :edit, :update, :destroy]

  # GET /activity_levels
  # GET /activity_levels.json
  def index
    @activity_levels = ActivityLevel.all
  end

  # GET /activity_levels/1
  # GET /activity_levels/1.json
  def show
    @activity_level = ActivityLevel.find(params[current_user])
  end

  # GET /activity_levels/new
  def new
    @activity_level = ActivityLevel.new(params[current_user])
  end

  # GET /activity_levels/1/edit
  def edit
    @activity_level = ActivityLevel.new(params[current_user])
  end

  # POST /activity_levels
  # POST /activity_levels.json
  def create
    @activity_level = ActivityLevel.new(activity_level_params)
    @activity_level.user_id = current_user
    @activity_level.save
    flash[:success] = "Activity Level Updated!"
    redirect_to root_url
  end

  # PATCH/PUT /activity_levels/1
  # PATCH/PUT /activity_levels/1.json
  def update
    respond_to do |format|
      if @activity_level.update(activity_level_params)
        format.html { redirect_to @activity_level, notice: 'Activity level was successfully updated.' }
        format.json { render :show, status: :ok, location: @activity_level }
      else
        format.html { render :edit }
        format.json { render json: @activity_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activity_levels/1
  # DELETE /activity_levels/1.json
  def destroy
    @activity_level.destroy
    respond_to do |format|
      format.html { redirect_to activity_levels_url, notice: 'Activity level was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity_level
      @activity_level = ActivityLevel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_level_params
      params.require(:activity_level).permit(:user_id, :activity_level)
    end
end
