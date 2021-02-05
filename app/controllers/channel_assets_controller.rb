class ChannelAssetsController < ApplicationController
  before_action :set_channel

  def index
    @channel_assets = ChannelAsset.all
  end

  def show
    @channel_assets = ChannelAsset.all
    @channel_asset = ChannelAsset.find(params[:id])
  end

  def new
    # authorize! :create, Channel
    @channel_assets = @channel.channel_assets.build
  end

  def edit
    @channel_asset = ChannelAsset.find(params[:id])
    # authorize! :update, @channel_assets
  end

  def create
    # authorize! :create, ChannelAsset
    # @channels = Channel.all
    @channel_asset = ChannelAsset.new(channel_asset_params)
    if @channel_asset.save
      flash[:danger] = "Your Channel has been created!"
      redirect_back fallback_location: root_path
    else
      redirect_back fallback_location: root_path
      flash[:danger] = "Failed to create your Channel"
    end
  end

  def update
    # authorize! :update, @channel_assets
    respond_to do |format|
      if @channel_asset.update_attributes(channel_asset_params)
        format.html { redirect_to @channel_asset, notice: 'Asset was successfully updated.' }
        format.json { render :show, status: :ok, location: @channel_asset }
      else
        format.html { render :edit }
        format.json { render json: @channel_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @channel_asset = ChannelAsset.find(params[:id])

    # authorize! :destroy, @channel_asset

    if @channel_asset.present?
      @channel_asset.destroy
    end
    respond_to do |format|
      format.html { redirect_to channel_assets_url, notice: 'Channel Asset was successfully deleted.' }
      format.json { head :no_content }
    end
  end



  private

  def set_channel
    @channel = Channel.find(params[:channel_id])
  end

  def channel_asset_params
    params.require(:channel_asset).permit(:asset_type, :source, :asset_name, :channel_id, :user_id, :description)
  end
end

