require_relative 'photo'
require_relative 'storage'
require 'logger'
require 'yaml'

class Organizer
  attr_reader :log

  def initialize source = "", destination = ""
    read_config
    setup_logging

    @source = source if source.length > 0
    @destination = destination if destination.length > 0

    @storage = Storage.new @log
    @files = @storage.get_files(@source, @extension)
    @log.info "#{@files.length} files found with #{@extension} extension."

    # go_organize
  end

  private
    def go_organize
      Dir.chdir @destination
      @files.each do |path|
        photo = Photo.new path
        @storage.mv photo.path, make_path(photo)
      end
    end

    def make_path photo
      "/%d/%02d/%s" % [photo.year, photo.month, photo.new_filename]
    end

    def read_config
      @config = YAML.load_file("config/config.yml")
      @config["storage"].each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def setup_logging
      @log = Logger.new(@config["logging"]["logfile"], 5, 10*1024)
      @log.level = Logger::DEBUG
      @log.datetime_format = "%H:%M:%S"
      @log.info "Organizer started"
    end
end

# Executable
Organizer.new '.'
