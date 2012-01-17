# bitlyr

## DESCRIPTION:

A Ruby API for [http://bit.ly](http://bit.ly)

[http://code.google.com/p/bitly-api/wiki/ApiDocumentation](http://code.google.com/p/bitly-api/wiki/ApiDocumentation)

## NOTE:

Bitly recently released their version 3 API. From this 0.9.0 release, the gem with only use the version 3 API.

The gem will continue to support both Username and ApiKey as well as the OAuth Client ID and Client Secret

To use, you will need to select a authorization strategy:

    strategy = Bitlyr::Strategy::ApiKey.new(username, api_key)

or

    strategy = Bitlyr::Strategy::OAuth.new(client_id, client_secret)

Once you have a strategy, you can initialize your client:

    client = Bitlyr::Client.new(strategy)

which will give you a ``Bitlyr::Client`` which provides access to the version 3 endpoints (``shorten``, ``expand``, ``clicks``, ``validate`` and ``bitly_pro_domain``). See [http://api.bit.ly](http://api.bit.ly) for details.


## INSTALLATION:

    gem install bitlyr

## USAGE:

Please see the Bit.ly API documentation [http://api.bit.ly](http://api.bit.ly) for details on the V3 API.

Create a Bitlyr client using your username and api key as follows:

    client = Bitlyr.new(:login => "login", :api_key => "api_key")

or

    client = Bitlyr.new(:client_id => "client id", :client_secret => "client secret", :token => "token")

You can then use that client to shorten or expand urls or return more information or statistics as so:

    client.shorten('http://www.google.com')
    client.shorten('http://www.google.com', :history => 1) # adds the url to the api user's history
    client.expand('wQaT') || client.expand('http://bit.ly/wQaT')
    client.info('wQaT')   || client.info('http://bit.ly/wQaT')
    client.stats('wQaT')  || client.info('http://bit.ly/wQaT')

Each can be used in all the methods described in the API docs, the shorten function, for example, takes a url or an array of urls.

All four functions return a ``Bitlyr::Url`` object (or an array of ``Bitlyr::Url`` objects if you supplied an array as the input). You can then get all the information required from that object.

    url = client.shorten('http://www.google.com') #=> Bitlyr::Url

    url.clicks_by_day    #=> an array of ``Bitlyr::Day``s
    url.countries        #=> an array of ``Bitlyr::Country``s
    url.referrers        #=> an array of ``Bitlyr::Referrer``s
    url.clicks_by_minute #=> an array of 60 integers representing clicks over the last 60 minutes
    url.created_by       #=> string  / http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/info
    url.global_clicks    #=> integer / http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/clicks
    url.global_hash      #=> string  / http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/info
    url.long_url         #=> string  / http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/expand
    url.new_hash?        #=> boolean / http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/shorten
    url.short_url        #=> string  / http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/shorten
    url.title            #=> string  / http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/info
    url.user_clicks      #=> integer / http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/clicks
    url.user_hash        #=> string  / http://code.google.com/p/bitly-api/wiki/ApiDocumentation#/v3/expand

## LICENSE:

> (The MIT License)
>
> Copyright (c) 2012 Jonathon Storer
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
