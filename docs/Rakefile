# frozen_string_literal: true

require 'rdoc/task'

RDoc::Task.new do |rdoc|
  rdoc.title = "ISO 1996 Documentation"
  rdoc.main = "README.md"
  rdoc.rdoc_dir = "doc"
  rdoc.rdoc_files.include("lib/**/*.rb", "README.md")
  rdoc.options << "--all" << "--hyperlink-all"
end

task default: :rdoc
