require 'nokogiri'

module Main
  class Ruby < Runner
    def run
      archive = Pathname("#{Dir.home}/Library/Application Support/Dash/DocSets/Ruby_2/Ruby.docset").join("Contents", "Resources", "tarix.tgz")
      CSV.generate do |csv|
        Zlib::GzipReader.open(archive) do |gz|
          Gem::Package::TarReader.new(gz) do |tar|
            tar.each do |entry|
              if entry.full_name =~ /\.html$/
                html = Nokogiri::HTML(entry.read)
                html.xpath('//div[@class="method-heading"]/span[@class="method-callseq"]').each do |method|
                  if method.text.strip =~ /^([^→\(]+)(?:\(([^\)→]+)\))?(?:\s*→.+)?$/u
                    method_name = $1.strip
                    parameters = []
                    parameters += $2.split(/,\s+/) unless $2.nil?
                    parameters.unshift(method_name, parameters.length)
                    csv << parameters
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
