require 'nokogiri'

module Main
  class Ruby < Runner
    def run
      Dir.glob("#{Dir.home}/Library/Application Support/Dash/DocSets/Ruby-2.5.0-ja/docsets/Ruby 2.5.0-ja.docset/Contents/Resources/Documents/method/**/*.html") do |file|
        html = Nokogiri::HTML(File.open(file))
        method_name = html.xpath('/html/body/h1[1]').text.split(' ').last
        p method_name
        break
      end
    end
  end
end
