require 'test_helper'
require 'id'

class IDTest < ActiveSupport::TestCase
  test "encrypt and decrypt" do
    assert 12 == ID.decrypt(ID.encrypt(12))
    assert 152 == ID.decrypt(ID.encrypt(152))
    assert 4564 == ID.decrypt(ID.encrypt(4564))
    assert 1 == ID.decrypt(ID.encrypt(1))
    assert 99999 == ID.decrypt(ID.encrypt(99999))
    assert 500000 == ID.decrypt(ID.encrypt(500000))
  end
end
