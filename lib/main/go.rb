module Main
  class Go < Runner
    def run
      archive = Pathname("#{Dir.home}/Library/Application Support/Dash/DocSets/Go/Go.docset").join("Contents", "Resources", "tarix.tgz")
      CSV.generate do |csv|
        Zlib::GzipReader.open(archive) do |gz|
          Gem::Package::TarReader.new(gz) do |tar|
            tar.each do |entry|
              if entry.full_name =~ /\.html$/
                html = Nokogiri::HTML(entry.read)
                html.xpath('/html/body/div/div/pre').each do |func|
                  if func.text.strip =~ /^func ((?:\([^)]+\))?\s*[^\s(]+)\(([^)]*)\)$/u
                    function_name = $1.strip
                    parameters = []
                    parameters += $2.split(/,\s+/) unless $2.nil?
                    parameters.unshift(function_name, parameters.length)
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