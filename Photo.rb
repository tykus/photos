require 'exifr'

class Photo
  attr_reader :path, :exif

  def initialize path
    @path = path
    @exif = extract_exif_data.exif
  end

  def new_filename
    "%4d-%02d-%02d %02d-%02d-%02d %s %s.jpg" % [date.year, date.month, date.day, date.hour, date.min, date.sec, @exif.make, @exif.model]
  end

  def year
    date.year
  end

  def month
    date.month
  end

  private

    # @TODO make instance variables of the EXIF data which is of interest to the application.

    def method_missing(m, *args)
      if @exif.methods.include?(m)
        return @exif.send(m)
      end
      super.missing_method(m)
    end

    def extract_exif_data
      EXIFR::JPEG.new @path
    end

    def date
      @exif.date_time
    rescue ArgumentError
      @exif.date_time_original
    end

end
