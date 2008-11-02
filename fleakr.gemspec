Gem::Specification.new do |s|
  s.name = %q{fleakr}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Patrick Reagan"]
  s.date = %q{2008-11-02}
  s.email = %q{reaganpr@gmail.com}
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["README.markdown", "Rakefile", "lib/fleakr", "lib/fleakr/version.rb", "lib/fleakr.rb", "test/fleakr_test.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://sneaq.net}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A teeny tiny gem to interface with Flickr photostreams}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
