class AssignedExercisePdf
  include RenderAnywhere

  def initialize(assigned, patient)
    @assigned = assigned
    @patient = patient
  end

  def to_pdf
    kit = PDFKit.new(as_html)
    kit.to_pdf
  end

  def as_html
    render template: "patients/exercises_memberships/show", layout: "exercise", locals: locals
  end

  private

  attr_reader :exercise

  def locals
    {
      :@assigned => @assigned,
      :@patient => @patient
    }
  end

end
