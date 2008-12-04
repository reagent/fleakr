# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fleakr}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Patrick Reagan"]
  s.date = %q{2008-12-04}
  s.email = %q{reaganpr@gmail.com}
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["README.markdown", "Rakefile", "lib/fleakr", "lib/fleakr/attribute.rb", "lib/fleakr/error.rb", "lib/fleakr/group.rb", "lib/fleakr/image.rb", "lib/fleakr/object.rb", "lib/fleakr/photo.rb", "lib/fleakr/request.rb", "lib/fleakr/response.rb", "lib/fleakr/search.rb", "lib/fleakr/set.rb", "lib/fleakr/user.rb", "lib/fleakr/version.rb", "lib/fleakr.rb", "test/fixtures", "test/fixtures/people.findByEmail.xml", "test/fixtures/people.findByUsername.xml", "test/fixtures/people.getInfo.xml", "test/fixtures/people.getPublicGroups.xml", "test/fixtures/people.getPublicPhotos.xml", "test/fixtures/photos.search.xml", "test/fixtures/photosets.getList.xml", "test/fixtures/photosets.getPhotos.xml", "test/fleakr", "test/fleakr/attribute_test.rb", "test/fleakr/error_test.rb", "test/fleakr/group_test.rb", "test/fleakr/image_test.rb", "test/fleakr/object_test.rb", "test/fleakr/photo_test.rb", "test/fleakr/request_test.rb", "test/fleakr/response_test.rb", "test/fleakr/search_test.rb", "test/fleakr/set_test.rb", "test/fleakr/user_test.rb", "test/test_helper.rb"]
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
      s.add_runtime_dependency(%q<activesupport>, ["~> 2.2.0"])
    else
      s.add_dependency(%q<hpricot>, ["~> 0.6.0"])
      s.add_dependency(%q<activesupport>, ["~> 2.2.0"])
    end
  else
    s.add_dependency(%q<hpricot>, ["~> 0.6.0"])
    s.add_dependency(%q<activesupport>, ["~> 2.2.0"])
  end
end
