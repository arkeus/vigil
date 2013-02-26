require "image_spec"

class S3Writer
  include AWS::S3
  
  def initialize
    super
    Base.establish_connection!(
      :access_key_id     => AMAZON_ACCESS_KEY_ID,
      :secret_access_key => AMAZON_SECRET_ACCESS_KEY
    ) unless Base.connected?
  end
  
  def self.get_path(key)
    return "https://s3.amazonaws.com/#{bucket}/#{key}"
  end
  
  # path: String
  # file: ActionDispatch::Http::UploadedFile or String
  def write(key, file)
    raise ArgumentError.new("File at #{get_path(key)} already exists") if exists?(key)
    type = "text/plain"
    width, height, type = dimensions(file.path) unless file.is_a?(String)
    S3Object.store(key, file.is_a?(String) ? file : File.open(file.path), self.class.bucket, :content_type => type)
  end
  
  def read(key)
    raise ArgumentError.new("File at #{get_path(key)} doesn't exist") unless exists?(key)
    return S3Object.find(key, self.class.bucket).value
  end
  
  def exists?(key)
    return S3Object.exists?(key, self.class.bucket)
  end
  
  def size(key)
    return S3Object.find(key, self.class.bucket).about['content-length']
  end
  
  def dimensions(path)
    instance = ImageSpec.new(path)
    return [instance.width, instance.height, instance.content_type]
  end
  
  def self.bucket
    return Rails.env.production? ? "vigil-paste" : "vigil-paste-test"
  end
end