class ID
  OFFSET = 1000
  BASE = 36
  
  # Not actually encryption, just makes shorter using letters and remaps
  # such that they are less sequential
  def self.encrypt(id)
    remap((id + OFFSET).to_s(BASE), MAP)
  end
  
  def self.decrypt(id)
    remap(id, INVERTED_MAP).to_i(BASE) - OFFSET
  end
  
  private
  
  MAP = {
    '0' => '6',
    '1' => 'p',
    '2' => 'c',
    '3' => 'o',
    '4' => '1',
    '5' => 'm',
    '6' => 'h',
    '7' => 'a',
    '8' => 'j',
    '9' => 'e',
    'a' => 't',
    'b' => 'y',
    'c' => '3',
    'd' => 's',
    'e' => 'd',
    'f' => 'q',
    'g' => 'b',
    'h' => 'i',
    'i' => 'v',
    'j' => '4',
    'k' => 'x',
    'l' => '7',
    'm' => 'f',
    'n' => '0',
    'o' => 'w',
    'p' => 'k',
    'q' => 'r',
    'r' => '8',
    's' => 'u',
    't' => '9',
    'u' => 'l',
    'v' => '5',
    'w' => 'g',
    'x' => '2',
    'y' => 'z',
    'z' => 'n'
  }
  
  INVERTED_MAP = MAP.invert
  
  def self.remap(id, map)
    return id.each_char.inject("") { |acc,char| acc << map[char]; acc }
  end
end