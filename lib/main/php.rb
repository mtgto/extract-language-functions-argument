require 'csv'
require 'nokogiri'
require 'pathname'
require 'zlib'
require 'rubygems/package'
require_relative 'runner'

module Main
  class Php < Runner
    def run
      archive = Pathname(@docset).join("Contents", "Resources", "tarix.tgz")
      CSV.generate do |csv|
        Zlib::GzipReader.open(archive) do |gz|
          Gem::Package::TarReader.new(gz) do |tar|
            tar.each do |entry|
              if entry.full_name =~ /\/php.net\/manual\/en\/function\.[^\/]+\.html$/
                html = Nokogiri::HTML(entry.read)
                function_name = html.xpath('/html/body/div[@id="layout"]/section[@id="layout-content"]/div/div/h1[@class="refname"][1]').text.strip
                parameters = []
                html.xpath('//div[@class="refsect1 parameters"]/dl/dt/code').each do |parameter|
                  parameters << parameter.text.strip
                end
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
