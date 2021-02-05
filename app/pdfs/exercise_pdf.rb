class ExercisePdf
  include RenderAnywhere

  def initialize(exercise)
    @exercise = exercise
  end

  def to_pdf
    kit = PDFKit.new(as_html)
    kit.to_pdf
  end

  def as_html
    render template: "exercises/show", layout: "exercise", locals: locals
  end

  private

  attr_reader :exercise

  def locals
    {:@exercise => @exercise}
  end

end
