class Writer
  def initialize; end
  
  def write(key, file)
    raise NotImplementedError
  end
  
  def read(key)
    raise NotImplementedError
  end
  
  def exists?(key)
    raise NotImplementedError
  end
  
  def size(key)
    raise NotImplementedError
  end
  
  def dimensions(key)
    raise NotImplementedError
  end
  
  def bucket
    return "vigil"
  end
end