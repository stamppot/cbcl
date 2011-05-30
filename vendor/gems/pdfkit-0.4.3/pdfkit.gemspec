# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pdfkit}
  s.version = "0.4.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["jdpace"]
  s.date = %q{2010-07-30}
  s.default_executable = %q{pdfkit}
  s.description = %q{Uses wkhtmltopdf to create PDFs using HTML}
  s.email = %q{jared@codewordstudios.com}
  s.executables = ["pdfkit"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    ".document",
     ".gitignore",
     ".rspec",
     "Gemfile",
     "Gemfile.lock",
     "LICENSE",
     "POST_INSTALL",
     "README.md",
     "Rakefile",
     "VERSION",
     "bin/pdfkit",
     "lib/pdfkit.rb",
     "lib/pdfkit/configuration.rb",
     "lib/pdfkit/middleware.rb",
     "lib/pdfkit/pdfkit.rb",
     "lib/pdfkit/source.rb",
     "pdfkit.gemspec",
     "spec/fixtures/example.css",
     "spec/fixtures/example.html",
     "spec/middleware_spec.rb",
     "spec/pdfkit_spec.rb",
     "spec/source_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/jdpace/PDFKit}
  s.post_install_message = %q{******************************************************************

Now install wkhtmltopdf binaries:
Global: sudo `which pdfkit` --install-wkhtmltopdf
or inside RVM folder: export TO=`which pdfkit | sed 's:/pdfkit:/wkhtmltopdf:'` && pdfkit --install-wkhtmltopdf
(run pdfkit --help to see more options)

******************************************************************}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{HTML+CSS -> PDF}
  s.test_files = [
    "spec/middleware_spec.rb",
     "spec/pdfkit_spec.rb",
     "spec/source_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.0.0.beta.8"])
      s.add_development_dependency(%q<rspec-core>, ["~> 2.0.0.beta.8"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.0.0.beta.8"])
      s.add_dependency(%q<rspec-core>, ["~> 2.0.0.beta.8"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.0.0.beta.8"])
    s.add_dependency(%q<rspec-core>, ["~> 2.0.0.beta.8"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
