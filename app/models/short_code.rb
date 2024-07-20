class ShortCode

  CHARSET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".freeze
  BASE = CHARSET.length

  def self.encode(number)
    return CHARSET[0] if number.zero? || number.nil?
    base62 = ""
    while number > 0
      reminder = number % BASE
      base62 = CHARSET[reminder] + base62
      number /= BASE
    end
    base62
  end

  def self.decode(base62)
    number = 0
    base62.each_char.with_index do |char, index|
      power = base62.length - (index + 1)
      number += CHARSET.index(char) * (BASE ** power)
    end
    number
  end
end
