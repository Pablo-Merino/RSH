require 'readline'

loop do
	line = Readline::readline('> ')
	break if line.nil? || line == 'quit'
	Readline::HISTORY.push(line)
	puts "You typed: #{line}"
end
