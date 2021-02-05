class MedicalConditionsController < ApplicationController


    def index
      @medical_conditions = MedicalCondition.all

      def show
        @medical_condition = MedicalCondition.find(params[:id])
      end

      def edit
        @medical_condition = current_user.dsm5
        @medical_condition = MedicalCondition.find(params[:id])
        authorize! :update, @medical_condition
      end

      def create
        authorize! :create, MedicalCondition
        @medical_condition = MedicalCondition.new(medical_condition_params)
        if @medical_condition.save
          flash[:success] = "successfully added!"
          redirect_back fallback_location: root_path
        else
          redirect_back fallback_location: root_path
          flash[:danger] = "Failed to create"
        end
      end

      def new
        authorize! :create, MedicalCondition
        @medical_condition = MedicalCondition.new(medical_condition_params)
      end

      def update
        respond_to do |format|
          if @medical_condition.update(medical_condition_params)
            format.html { redirect_to @medical_condition, notice: 'successfully updated.' }
            format.json { render :show, status: :ok, location: @medical_condition }
          else
            format.html { render :edit }
            format.json { render json: @medical_condition.errors, status: :unprocessable_entity }
          end
        end
      end


      def destroy
        @medical_condition.destroy
        respond_to do |format|
          format.html { redirect_to medical_condition_url, notice: 'successfully destroyed.' }
          format.json { head :no_content }
        end
      end


    end
    private

    def medical_condition_params
      params.require(:@medical_condition).permit(:long_description, :short_description, :is_dsm5, :order_number, :is_not_header, :dsm_code, :icd10_code, :id)
    end


end

