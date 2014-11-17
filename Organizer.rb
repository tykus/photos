require_relative 'Photo'
require_relative 'Storage'
require 'logger'
require 'yaml'

class Organizer

  def initialize source = "", destination = ""
    read_config
    setup_logging

    @source = source if source.length > 0
    @destination = destination if destination.length > 0

    @storage = Storage.new @log
    @files = @storage.get_files(@source, @extension)
    @log.info "#{@files.length} files found with '#{@extension}' extension."

    go_organize
  end

  private
    def go_organize
      Dir.chdir @destination
      @files.each do |path|
        photo = Photo.new path, @log
        @storage.move(photo.path, make_path(photo)) unless photo.exif.nil?
      end
    end

    def make_path photo
      "#{@destination}/%d/%02d/%s" % [photo.year, photo.month, photo.new_filename]
    end

    def read_config
      @config = YAML.load_file("config/config.yml")
      @config["storage"].each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def setup_logging
      @log = Logger.new(@config["logging"]["logfile"], 'daily')
      @log.level = Logger::DEBUG
      @log.datetime_format = "%H:%M:%S"
      @log.info "Organizer started\nSorting #{@extension} files in #{@source}"
    end
end

# Executable
Organizer.new
