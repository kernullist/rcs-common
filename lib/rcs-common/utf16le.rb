#
# Helper method for decoding windows WCHAR strings.
#

require 'stringio'

class StringIO
  def read_utf16le_string
    # at least the null terminator
    return nil if self.size < 2

    # empty string by default
    str = ''
    # read until the end of buffer or null termination
    until self.tell == self.size do
      t = self.read(2)
      break if t == "\0\0"
      str += t
    end

    # misaligned string
    return nil if str.bytesize % 2 != 0

    return str
  end
end

class String
  def to_binary
    self.unpack("H*").pack("H*")
  end

  def to_utf16le_binary
    self.encode('UTF-16LE').to_binary
  end

  def to_utf16le_binary_null
    # with null termination
    (self + "\0").to_utf16le_binary
  end

  def to_utf16le
    self.encode('UTF-16LE')
  end

  def utf16le_to_utf8
    self.force_encoding('UTF-16LE').encode('UTF-8').chomp("\0")
  end
end
