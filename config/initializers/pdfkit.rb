# # config/initializers/pdfkit.rb
if Rails.env.development?
  PDFKit.configure do |config|
    # config.wkhtmltopdf = 'C:\Ruby193\wkhtmltopdf\bin\wkhtmltopdf.exe'
    config.default_options = {
      page_size: 'Legal',
      print_media_type: true,
      dpi: 400
    }
    # Use only if your external hostname is unavailable on the server.
    # config.root_url = "http://localhost:5000"
    config.verbose = false
  end
end
