require_relative 'photo'

class Organizer

  def initialize source, destination
    @source = source
    @destination = destination
    go_organize if paths_are_valid
  end

  private
    def paths_are_valid
      valid = true
      [@source, @destination].each do |path|
        valid &&= Dir.exists? path
      end
    end

    def go_organize
      Dir.chdir @destination
      get_files.each do |path|
        photo = Photo.new path
        # File.rename(path, make_path(photo))
        puts make_path(photo)
      end
    end

    def make_path photo
      "/%d/%02d/%s" % [photo.year, photo.month, photo.new_filename]
    end

    def get_files
      Dir["#{@source}/**/*.{JPG,jpg}"]
    end
end
