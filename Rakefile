$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'
require 'bundler/gem_tasks'

if ARGV.join(' ') =~ /spec/
  Bundler.require :default, :spec
else
  Bundler.require
end

require './lib/enchanted_quill'

Motion::Project::App.setup do |app|
  app.name = 'EnchantedQuill'
  app.frameworks += %w(Foundation UIKit)
end
