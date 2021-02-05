class PdfMailer < ApplicationMailer
  def member_summary(member, address)
    @member = member
    pdf = MemberSummaryPdf.new(@member).to_pdf
    attachments["#{@member}_summary.pdf"] = pdf

    mail to: address, subject: "Summary for FARO10 user #{@member}"
  end
end
