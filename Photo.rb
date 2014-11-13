require 'exifr'

class Photo
  attr_reader :path, :exif

  def initialize path
    @path = path
    @exif = extract_exif_data.exif
  end

  private
    def extract_exif_data
      EXIFR::JPEG.new @path
    end

end
