# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fleakr}
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Patrick Reagan"]
  s.date = %q{2008-12-12}
  s.email = %q{reaganpr@gmail.com}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/fleakr", "lib/fleakr/api", "lib/fleakr/api/request.rb", "lib/fleakr/api/response.rb", "lib/fleakr/objects", "lib/fleakr/objects/contact.rb", "lib/fleakr/objects/error.rb", "lib/fleakr/objects/group.rb", "lib/fleakr/objects/image.rb", "lib/fleakr/objects/photo.rb", "lib/fleakr/objects/search.rb", "lib/fleakr/objects/set.rb", "lib/fleakr/objects/user.rb", "lib/fleakr/support", "lib/fleakr/support/attribute.rb", "lib/fleakr/support/object.rb", "lib/fleakr/version.rb", "lib/fleakr.rb", "test/fixtures", "test/fixtures/contacts.getPublicList.xml", "test/fixtures/groups.pools.getPhotos.xml", "test/fixtures/people.findByEmail.xml", "test/fixtures/people.findByUsername.xml", "test/fixtures/people.getInfo.xml", "test/fixtures/people.getPublicGroups.xml", "test/fixtures/people.getPublicPhotos.xml", "test/fixtures/photos.getSizes.xml", "test/fixtures/photos.search.xml", "test/fixtures/photosets.getList.xml", "test/fixtures/photosets.getPhotos.xml", "test/test_helper.rb", "test/unit", "test/unit/fleakr", "test/unit/fleakr/api", "test/unit/fleakr/api/request_test.rb", "test/unit/fleakr/api/response_test.rb", "test/unit/fleakr/objects", "test/unit/fleakr/objects/contact_test.rb", "test/unit/fleakr/objects/error_test.rb", "test/unit/fleakr/objects/group_test.rb", "test/unit/fleakr/objects/image_test.rb", "test/unit/fleakr/objects/photo_test.rb", "test/unit/fleakr/objects/search_test.rb", "test/unit/fleakr/objects/set_test.rb", "test/unit/fleakr/objects/user_test.rb", "test/unit/fleakr/support", "test/unit/fleakr/support/attribute_test.rb", "test/unit/fleakr/support/object_test.rb", "test/unit/fleakr_test.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://sneaq.net}
  s.rdoc_options = ["--main", "README.rdoc"]
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
