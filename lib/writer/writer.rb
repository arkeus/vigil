class Writer
  def initialize; end
  
  def write(path, file)
    raise NotImplementedError
  end
  
  def read(path)
    raise NotImplementedError
  end
  
  def exists?(path)
    raise NotImplementedError
  end
  
  def size(path)
    raise NotImplementedError
  end
  
  def dimensions(path)
    raise NotImplementedError
  end
  
  def bucket
    return "vigil"
  end
end