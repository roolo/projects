require 'find'
require 'logger'
require 'open3'

namespace :proj do
  desc "Updates all projects"
  task :update_all do
    Find.find('../..') do |f|
      if f =~ /\.git$/
        zshin, zshout, zsherr = Open3.popen3('zsh')
        repository = f.gsub /\.git$/, ''
        Logger.new(STDOUT).info('Checking '){repository}
        zshin.puts 'cd %s'%repository
        zshin.puts 'git up'
        zshin.puts 'exit'
        while (line = zshout.gets)
          puts line
        end
      end
    end
  end
end
