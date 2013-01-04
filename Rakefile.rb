require 'find'
require 'logger'

namespace :proj do
  desc "Updates all projects"
  task :update_all do
    Find.find('../..') do |f|
      if f =~ /\.git$/
        repository = f.gsub /\.git$/, ''
        Logger.new(STDOUT).info('Checking '){repository}
        Dir.chdir(repository){
          puts `git up`
        }
      end
    end
  end
end
