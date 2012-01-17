# bitlyr

## DESCRIPTION:

A Ruby API for [http://bit.ly](http://bit.ly)

[http://code.google.com/p/bitly-api/wiki/ApiDocumentation](http://code.google.com/p/bitly-api/wiki/ApiDocumentation)

## NOTE:

Bitly recently released their version 3 API. From this 0.8.0 release, the gem with only use the version 3 API.

The gem will continue to support both Username and ApiKey as well as the OAuth Client ID and Client Secret

To use, you will need to select a authorization strategy:

    strategy = Bitly::Strategy::ApiKey.new(username, api_key)

or

    strategy = Bitly::Strategy::OAuth.new(client_id, client_secret)

Once you have a strategy, you can initialize your client:

    client = Bitly::Client.new(strategy)

which will give you a ``Bitly::Client`` which provides access to the version 3 endpoints (``shorten``, ``expand``, ``clicks``, ``validate`` and ``bitly_pro_domain``). See [http://api.bit.ly](http://api.bit.ly) for details.


## INSTALLATION:

    gem install bitlyr

## USAGE:

Please see the Bit.ly API documentation [http://api.bit.ly](http://api.bit.ly) for details on the V3 API.

Create a Bitly client using your username and api key as follows:

    bitly = Bitly.new(:login => "login", :api_key => "api_key")

You can then use that client to shorten or expand urls or return more information or statistics as so:

    bitly.shorten('http://www.google.com')
    bitly.shorten('http://www.google.com', :history => 1) # adds the url to the api user's history
    bitly.expand('wQaT') || bitly.expand('http://bit.ly/wQaT')
    bitly.info('wQaT')   || bitly.info('http://bit.ly/wQaT')
    bitly.stats('wQaT')  || bitly.info('http://bit.ly/wQaT')

Each can be used in all the methods described in the API docs, the shorten function, for example, takes a url or an array of urls.

All four functions return a ``Bitly::Url`` object (or an array of ``Bitly::Url`` objects if you supplied an array as the input). You can then get all the information required from that object.

    u = bitly.shorten('http://www.google.com') #=> Bitly::Url

    u.long_url  #=> "http://www.google.com&quot;
    u.short_url #=> "http://bit.ly/Ywd1&quot;
    u.bitly_url #=> "http://bit.ly/Ywd1&quot;
    u.jmp_url   #=> "http://j.mp/Ywd1&quot;
    u.user_hash #=> "Ywd1"
    u.hash      #=> "2V6CFi"
    u.info      #=> a ruby hash of the JSON returned from the API
    u.stats     #=> a ruby hash of the JSON returned from the API

    bitly.shorten('http://www.google.com', 'keyword')

## LICENSE:

> (The MIT License)
>
> Copyright (c) 2009 Phil Nash
>
> Permission is hereby granted, free of charge, to any person obtaining
> a copy of this software and associated documentation files (the
> 'Software'), to deal in the Software without restriction, including
> without limitation the rights to use, copy, modify, merge, publish,
> distribute, sublicense, and/or sell copies of the Software, and to
> permit persons to whom the Software is furnished to do so, subject to
> the following conditions:
>
> The above copyright notice and this permission notice shall be
> included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
> EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
> IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
> CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
> TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
> SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
