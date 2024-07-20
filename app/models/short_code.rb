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

  def self.decode(value)
  end
end
