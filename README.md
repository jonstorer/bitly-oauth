# bitly-oauth

## STATUS

[![Build Status](https://secure.travis-ci.org/jonstorer/bitly-oauth.png)](http://travis-ci.org/jonstorer/bitly-oauth)

## DESCRIPTION:

A Ruby API for [http://bit.ly](http://bit.ly)

[http://code.google.com/p/bitly-api/wiki/ApiDocumentation](http://code.google.com/p/bitly-api/wiki/ApiDocumentation)

## NOTE:

BitlyOAuth supports version 3 of the API as well as OAuth authenticate for user access.

To use, you will need a client id and client secret. Get yours at [http://bitly.com/a/account](http://bitly.com/a/account).

    client = BitlyOAuth::Client.new(client_id, client_secret)

With a ``BitlyOAuth::Client`` you have access to the following API endpoints:
``shorten``, ``expand``, ``lookup``, ``info``, ``clicks``, ``clicks_by_minute``,
``clicks_by_day``, ``countries``, ``referrers``, ``referring_domains``,
``validate``, ``bitly_pro_domain``  See [http://bit.ly/apidocs](http://bit.ly/apidocs) for details.

## INSTALLATION:

    gem install bitly-oauth

## USAGE:

Please see the Bit.ly API documentation [http://bit.ly/apidocs](http://bit.ly/apidocs) for details on the V3 API.

You can initialize a client through the following shortcut as well:

    client = BitlyOAuth.new("client id", "client secret")
    client.set_access_token_from_token('token')

You can then use that client to shorten or expand urls or return more information or statistics as so:

    client.shorten('http://www.google.com')
    client.shorten('http://www.google.com', :history => 1) # adds the url to the api user's history

    client.expand('wQaT') || client.expand('http://bit.ly/wQaT')
    client.info('wQaT')   || client.info('http://bit.ly/wQaT')
    client.stats('wQaT')  || client.stats('http://bit.ly/wQaT')

Each can be used in all the methods described in the API docs, the shorten function, for example, takes a url or an array of urls.

Then functions ``shorten``, ``expand``, ``info``, and ``stats`` return a ``BitlyOAuth::Url`` object (or an array of ``BitlyOAuth::Url`` objects if you supplied an array as the input). You can then get all the information required from that object.

    url = client.shorten('http://www.google.com') #=> BitlyOAuth::Url

    url.clicks_by_day    #=> an array of ``BitlyOAuth::Day``s
    url.countries        #=> an array of ``BitlyOAuth::Country``s
    url.referrers        #=> an array of ``BitlyOAuth::Referrer``s
    url.clicks_by_minute #=> an array of 60 integers representing click counts over the last 60 minutes
    url.created_by       #=> string  / http://bit.ly/apidocs#/v3/info
    url.global_clicks    #=> integer / http://bit.ly/apidocs#/v3/clicks
    url.global_hash      #=> string  / http://bit.ly/apidocs#/v3/info
    url.long_url         #=> string  / http://bit.ly/apidocs#/v3/expand
    url.new_hash?        #=> boolean / http://bit.ly/apidocs#/v3/shorten
    url.short_url        #=> string  / http://bit.ly/apidocs#/v3/shorten
    url.title            #=> string  / http://bit.ly/apidocs#/v3/info
    url.user_clicks      #=> integer / http://bit.ly/apidocs#/v3/clicks
    url.user_hash        #=> string  / http://bit.ly/apidocs#/v3/expand

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
