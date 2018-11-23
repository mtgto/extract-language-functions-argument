require 'csv'
require 'sqlite3'

module Main
  class Java < Runner
    def run
      CSV.generate do |csv|
        db = SQLite3::Database.new("#{Dir.home}/Library/Application Support/Dash/DocSets/Java_SE11/Java.docset/Contents/Resources/docSet.dsidx")
        db.execute("SELECT ZTOKENNAME FROM ZTOKEN WHERE ZTOKENTYPE = 7;") do |row|
          if row.first =~ /^([^(]+)\((.*)\)$/
            method_name = $1
            parameters = []
            depth = 0
            parameter = ''
            $2.each_char do |c|
              case c
              when '<'
                parameter << c
                depth = depth + 1
              when '>'
                parameter << c
                depth = depth - 1
              else
                if depth == 0 and c == ','
                  parameters << parameter.lstrip
                  parameter = ''
                else
                  parameter << c
                end
              end
            end
            parameters << parameter.lstrip unless parameter.empty?
            parameters.unshift(method_name, parameters.length)
            csv << parameters
          end
        end
        db.close
      end
    end
  end
end
