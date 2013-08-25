namespace :proj do
  desc 'Updates all projects'
  task :update_all do
    require 'find'
    require 'logger'
    require 'open3'

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

  desc 'Generates Gemfile (Separate gems by |)'
  task :gemfile, :gems, :project_path do |t, args|
    require 'erb'
    require 'rubygems'

    longest_gem = 0

    unless args[:gems]
      puts 'No params... I will do nothing! ' +
        'Try: rake proj:gemfile\[\'rspec|sequel\'\] '
      exit 1
    end

    gems = args[:gems].split('|').inject([]) do |gems_data, gem_name|
      longest_gem = gem_name.length if gem_name.length > longest_gem
      gems_data << { name:    gem_name,
                     latest:  Gem.latest_spec_for(gem_name).version.to_s
      }
    end

    out = gems.inject("source 'https://rubygems.org'\n\n"){|gemfile_output, gem|
      aligned_name = ("'%s',"%gem[:name]).ljust(longest_gem+3)

      gemfile_output << "gem %s '~> %s'\n"%[
        aligned_name,
        gem[:latest]
      ]
    }

    if args[:project_path]
      unless Dir.exist? args[:project_path]
        raise 'Invalid path: '+args[:project_path]
      end
      File.open(args[:project_path]+'/Gemfile', 'w+') {|f| f.write(out) }
    else
      puts out
    end
  end
end
