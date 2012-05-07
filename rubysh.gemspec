Gem::Specification.new do |s|
  s.name    = 'RubySH'
  s.version = '1.0'
  s.summary = 'RSH is a SH compliant shell, completely coded in Ruby'
  s.description = 'RSH is a UNIX and SH compliant shell built in Ruby. It features all the traditional Shell commands (basically anything in the $PATH)'

  s.authors  = ['Pablo Merino']
  s.email    = ['pablo.perso1995@gmail.com']
  s.homepage = 'https://github.com/pablo-merino/rsh'

  s.files    = Dir['./**/*']

  # Supress the warning about no rubyforge project
  s.rubyforge_project = 'nowarning'
  s.executables   = `ls bin/*`.split("\n").map{ |f| File.basename(f) }

end
