# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{colorize}
  s.version = "0.5.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["fazibear"]
  s.date = %q{2009-12-02}
  s.description = %q{Ruby string class extension. It add some methods to set color, background color and text effect on console easier. Uses ANSI escape sequences.}
  s.email = %q{fazibear@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = [".gitignore", "CHANGELOG.rdoc", "README.rdoc", "Rakefile", "VERSION", "colorize.gemspec", "lib/colorize.rb", "test/test_colorize.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/fazibear/colorize}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.4.2}
  s.summary = %q{Add colors methods to string class}
  s.test_files = ["test/test_helper.rb", "test/test_colorize.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
