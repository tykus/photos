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
    if not valid_path?(new_path) make_directory(new_path)
    File.rename old_path, new_path if valid_path?(old_path)
  end

  def

  def valid_path? path
    if not (File.directory?(path) && Dir.exists?(path))
      @log.warn "The path #{path} was not found or is not a directory."
      return false
    end
    return true
  end

  def make_directory path
    path.split('/').each do |dir|
      Dir.mkdir(dir) if not Dir.exists?(dir)
      Dir.chdir(dir)
    end
  end

  private :valid_path?, :make_directory

end
