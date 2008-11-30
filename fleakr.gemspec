# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fleakr}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Patrick Reagan"]
  s.date = %q{2008-11-29}
  s.email = %q{reaganpr@gmail.com}
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["README.markdown", "Rakefile", "lib/fleakr", "lib/fleakr/error.rb", "lib/fleakr/photo.rb", "lib/fleakr/request.rb", "lib/fleakr/response.rb", "lib/fleakr/set.rb", "lib/fleakr/user.rb", "lib/fleakr/version.rb", "lib/fleakr.rb", "test/fixtures", "test/fixtures/people.findByUsername.xml", "test/fixtures/photosets.getList.xml", "test/fixtures/photosets.getPhotos.xml", "test/fleakr", "test/fleakr/error_test.rb", "test/fleakr/photo_test.rb", "test/fleakr/request_test.rb", "test/fleakr/response_test.rb", "test/fleakr/set_test.rb", "test/fleakr/user_test.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://sneaq.net}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A teeny tiny gem to interface with Flickr photostreams}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, ["~> 0.6.0"])
    else
      s.add_dependency(%q<hpricot>, ["~> 0.6.0"])
    end
  else
    s.add_dependency(%q<hpricot>, ["~> 0.6.0"])
  end
end
