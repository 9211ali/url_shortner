require 'open-uri'
require 'nokogiri'

class Metadata
  attr_reader :doc

  def self.retrieve_from(url)
    new(URI.open(url).read)
  rescue OpenURI::HTTPError, SocketError => e
    puts "Failed to retrieve content from URL: #{e.message}"
    nil
  end

  def initialize(html = nil)
    if html
      @doc = Nokogiri::HTML(html)
    else
      @doc = Nokogiri::HTML('')
    end
  end

  def attributes
    {
      title: title,
      description: description,
      image: image
    }
  end

  def title
    doc.at_css("title")&.text
  end

  def description
    meta_tag_content('description')
  end

  def image
    meta_tag_content('og:image', attribute_name: :property)
  end

  private

  def meta_tag_content(name, attribute_name: :name)
    doc.at_css("meta[#{attribute_name}='#{name}']")&.attributes&.fetch('content', nil)&.value
  end
end
