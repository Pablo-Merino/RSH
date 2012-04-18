# encoding: utf-8
require './require.rb'

module RubySH
	class Shell
		def initialize
			if File.exists?(".rsh")
				@config = YAML.load_file(".rsh")
			else
				@config = YAML.load_file("~/.rsh")
			end

			@version = @config['version']
			if @config['debug']
				@debug = true
			end
			Screen.clear
			trap('SIGINT') { exit unless @debug.nil? }
		end
		def prompt
			puts "#{Time.now.strftime("%I:%M%p %m/%d/%Y")}".bright.cyan
			loop {
				# apparently colorize gem makes readlines glitch...
				prompt = parse_prompt(ENV['rsh_ps1'])

				buf = Readline::readline(prompt, true)
				enter(buf)				
			}

		end

		def enter(data)
			splitted_command = data.split(" ")
			command = splitted_command[0]
			splitted_command.shift
			args = splitted_command.join(" ")

			# hooking commands yay
			if !command.nil?
					case command
						when 'cd'
							begin
								if args == "~"
									Dir.chdir(ENV['HOME'])
								else
									Dir.chdir(args)
								end
							rescue Errno::ENOENT => e
								puts "#{args}: Directory not found!".red
							end
						when 'export'
							args = args.split('=')
							ENV[args[0]] = args[1].gsub('"', '')
						when 'quit'
							exit
						when 'help'
							print_help
						when 'about'
							print_about
						when 'eval'
							eval_code(args)
						else
							if File.exists?("#{Dir.pwd}/#{command.gsub("./", "")}")
								pid = fork {
									exec "#{command} #{args}"
								}
								Process.wait pid

							elsif command?(command)
								puts "command: #{command}\nargs: #{args}" unless @debug.nil?
								pid = fork {
									exec "#{command} #{args}"
								}
								Process.wait pid
							else
								puts "rsh: '#{command}' not found".red
							end
					end
				
			else
				Readline::HISTORY.pop
			end
		
		end

		def command?(program)
  			ENV['PATH'].split(File::PATH_SEPARATOR).any? do |directory|
    			File.executable?(File.join(directory, program.to_s))
  			end
		end

		def current_dir?(path_type)
			path_type ? Dir.pwd.gsub(ENV['HOME'], '~') : Dir.pwd
			
		end

		def eval_code(args)
			if args.nil?
				puts "Usage: eval <ruby code>"
			else
				puts eval args
			end
		end

		def print_about
			puts "RubySH (rsh) #{@version}".red
			puts "RubySH is a UNIX shell completely written using Ruby language.".light_red
			puts "Built by Pablo Merino ☭\n"
		end

		def parse_prompt(prompt_str)
			returner = prompt_str.gsub(/\/p/, current_dir?(true)).gsub(/\/u/, ENV['USER']).gsub(/\/t/, Time.now.strftime("%I:%M%p %m/%d/%Y"))
			returner
		end
	end
end