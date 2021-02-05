class ExercisesController < ApplicationController

  def show
    @exercise = Exercise.includes(:questions).find(params[:id])
    authorize! :read, @exercise
  end

  def pdf
    @exercise = Exercise.includes(:questions).find(params[:id])
    pdf = ExercisePdf.new(@exercise)

    respond_to do |format|
      format.pdf do
        send_data pdf.to_pdf, type: :pdf, disposition: "inline"
      end
    end
  end

end
