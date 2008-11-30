# Fleakr

## Description

A teeny tiny gem to interface with Flickr photostreams

## Installation

    sudo gem install reagent-fleakr --source=http://gems.github.com
    
Or ...

    $ git clone git://github.com/reagent/fleakr.git
    $ cd fleakr
    $ rake gem && sudo gem install pkg/fleakr-<version>.gem

## Usage

Before doing anything, require the library:

    >> require 'rubygems'
    >> require 'fleakr'

Then, set your API key (only need to do this once per session):

    >> Fleakr::Request.api_key = '<your api key here>'
    
Find a user by username:

    >> user = Fleakr::User.find_by_username('the decapitator')
    => #<Fleakr::User:0x692648 @username="the decapitator", @id="21775151@N06">

And that user's associated sets:

    >> user.sets
    => [#<Fleakr::Set:0x671358 @title="The Decapitator", @description="">, 
        #<Fleakr::Set:0x66d898 @title="londonpaper hijack", ...

## TODO

* Refactor the attribute retrieval to something more reusable
* Implement remaining bits of person, photoset, and photo-releated APIs
        
## License

Copyright (c) 2008 Patrick Reagan (reaganpr@gmail.com)

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
