require "writer/writer"
require "image_spec"

class FileWriter < Writer
  def initialize
    super
  end
  
  def get_path(key)
    return File.join(root, key)
  end
  
  # path: String
  # file: ActionDispatch::Http::UploadedFile or String
  def write(path, file)
    raise ArgumentError.new("File at #{path} already exists") if exists?(path)
    File.open(path, "wb") { |f| f.write(file.is_a?(String) ? file : file.read) }
  end
  
  def read(path)
    raise ArgumentError.new("File at #{path} already exists") unless exists?(path)
    File.open(path, "rb") { |f| return f.read }
  end
  
  def exists?(path)
    return File.exists?(path) && File.file?(path)
  end
  
  def size(path)
    return File.size(path)
  end
  
  def dimensions(path)
    instance = ImageSpec.new(path)
    return [instance.width, instance.height, instance.content_type]
  end
  
  def root
    base = case
      when Rails.env.production? then "~/files/vigil"
      when Rails.env.development? then "C:/Dev/Workspace/Files"
      when Rails.env.test? then Dir.tmpdir
    end
    return File.join(base, bucket)
  end
end