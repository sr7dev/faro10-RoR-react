class UserStatusesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  # GET /user_statuses
  # GET /user_statuses.json
  def index
    @user_statuses = UserStatus.all
  end

  # GET /user_statuses/1
  # GET /user_statuses/1.json
  def show
    @user_status = UserStatus.find(params[current_user])
  end

  # GET /user_statuses/new
  def new
    @user_status = UserStatus.new(params[current_user])
  end

  # GET /user_statuses/1/edit
  def edit
    @user_status = UserStatus.edit(params[current_user])
  end

  # POST /user_statuses
  # POST /user_statuses.json
  def create
    @user_status = UserStatus.new(user_status_params)
    @user_status.user_id = current_user
    @user_status.save
      flash[:success] = "Status Updated!"
    redirect_to root_url
  end

  # PATCH/PUT /user_statuses/1
  # PATCH/PUT /user_statuses/1.json
  def update
    respond_to do |format|
      if @user_status.update(user_status_params)
        format.html { redirect_to @user_status, notice: 'User status was successfully updated.' }
        format.json { render :show, status: :ok, location: @user_status }
      else
        format.html { render :edit }
        format.json { render json: @user_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_statuses/1
  # DELETE /user_statuses/1.json
  def destroy
    @user_status.destroy
    respond_to do |format|
      format.html { redirect_to user_statuses_url, notice: 'User status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_status
      @user_status = UserStatus.find(params[current_user])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_status_params
      params.require(:user_status).permit(:user_id, :journal_entry, :anx_attack, :have_headache)
    end
end

