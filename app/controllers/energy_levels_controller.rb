class EnergyLevelsController < ApplicationController
  before_action :set_energy_level, only: [:show, :edit, :update, :destroy]

  # GET /energy_levels
  # GET /energy_levels.json
  def index
    @energy_levels = EnergyLevel.all
  end

  # GET /energy_levels/1
  # GET /energy_levels/1.json
  def show
    @energy_level = EnergyLevel.find(params[current_user])
  end

  # GET /energy_levels/new
  def new
    @energy_level = EnergyLevel.new(params[current_user])
  end

  # GET /energy_levels/1/edit
  def edit
    @energy_level = EnergyLevel.edit(params[current_user])
  end

  # POST /energy_levels
  # POST /energy_levels.json


  def create
    @energy_level = EnergyLevel.new(energy_level_params)
    @energy_level.user_id = current_user
    @energy_level.save
    flash[:success] = "Energy Level Updated!"
    redirect_to root_url
  end

  # PATCH/PUT /energy_levels/1
  # PATCH/PUT /energy_levels/1.json
  def update
    respond_to do |format|
      if @energy_level.update(energy_level_params)
        format.html { redirect_to @energy_level, notice: 'Energy level was successfully updated.' }
        format.json { render :show, status: :ok, location: @energy_level }
      else
        format.html { render :edit }
        format.json { render json: @energy_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /energy_levels/1
  # DELETE /energy_levels/1.json
  def destroy
    @energy_level.destroy
    respond_to do |format|
      format.html { redirect_to energy_levels_url, notice: 'Energy level was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_energy_level
      @energy_level = EnergyLevel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def energy_level_params
      params.require(:energy_level).permit(:user_id, :energy_level)
    end
end
