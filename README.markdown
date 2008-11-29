# Fleakr

## Description

A teeny tiny gem to interface with Flickr photostreams

## Installation

    sudo gem install reagent-fleakr
    
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

    >> user = Fleakr::User.find_by_username('mharmanlikli')
    => #<Fleakr::User:0x1013c58 @id="23699283@N00", @username="mharmanlikli">

And that user's associated sets:

    >> user.sets
    => [#<Fleakr::Set:0x1002980 @title="birdy", @description="">,
        #<Fleakr::Set:0x100147c @title="every loneliness is a revolution", @description="">,
        #<Fleakr::Set:0x71c500 @title="my eyes are window for children", @description="">]
        
## TODO

* Refactor the attribute retrieval to something more reusable
* Add better error handling for all API calls
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
