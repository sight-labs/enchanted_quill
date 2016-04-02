require "enchanted_quill/version"

unless defined?(Motion::Project::App)
  raise "This must be required from within a RubyMotion Rakefile"
end

Motion::Project::App.setup do |app|
  lib_dir = File.join(File.dirname(__FILE__))
  app.files.unshift(Dir.glob(File.join(lib_dir, "enchanted_quill/**/*.rb")))
  app.frameworks += %{ Foundation UIKit }
end
