require './require.rb'

module RubySH
	class Shell
		def initialize(debug)
			@config = YAML.load_file(".rsh")

			@version = @config['version']
			if @config['debug']
				@debug = true
			end
			Screen.clear
			stty_save = `stty -g`.chomp
			trap('SIGINT') { system('stty', stty_save); exit unless @debug.nil? }
		end
		def prompt
			puts "#{Time.now.strftime("%I:%M%p %m/%d/%Y")}"

			loop {
				buf = Readline.readline("#{current_dir?.gsub(ENV['HOME'], '~').white.bright} % ", true)
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
								Dir.chdir(args)
							rescue Errno::ENOENT => e
								puts "#{args}: Directory not found!".red
							end
						when 'export'
							args = args.split('=')
							ENV[args[0]] = args[1]
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
								system("#{command} #{args}")
							else
								puts "rsh: '#{command}' not found".red
							end
					end
				
			end
		
		end

		def command?(program)
  			ENV['PATH'].split(File::PATH_SEPARATOR).any? do |directory|
    			File.executable?(File.join(directory, program.to_s))
  			end
		end

		def current_dir?
			Dir.pwd
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
			puts "Built by Pablo Merino\n"
		end
	end
end