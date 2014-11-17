require 'logger'

class Storage

  def initialize log=Logger.new(STDOUT)
    @log = log
  end

  def get_files path, ext="*"
    if not valid_path? path
      raise ArgumentError, "Path #{path} does not exist"
    end
    ext = "{#{ext.upcase},#{ext.downcase}}" if ext != "*"
    Dir["#{path}/**/*.#{ext}"]
  end

  def move old_path, new_path
    destination_directory = File.split(new_path)[0]
    unless valid_path?(destination_directory)
      @log.warn "Destination directory does not exist - creating it now."
      make_directory(destination_directory)
    end

    if File.exists? new_path
      @log.warn "File already exists at #{new_path}"
    else
      @log.info "Moving file from #{old_path} to #{new_path}"
      print "."
      File.rename(old_path, new_path) unless File.exists?(new_path)
    end
  end

  def valid_path?(path)
    Dir.exists?(path) && File.directory?(path)
  end

  def make_directory path
    @log.info "Making new directory at #{path}"
    path.split('/').each do |dir|
      dir = '/' if dir == ""
      unless Dir.exists?(dir)
        Dir.mkdir(dir)
      end
      Dir.chdir(dir)
    end
  end

  private :valid_path?, :make_directory

end
