# Spree on Heroku

This is an extension for Spree, allowing the e-commerce system to run on Heroku - http://heroku.com.

The major constraint on Heroku is that we can't write files to disk, so this extension disables all disk caching, fixes a few issues and changes Spree to store on Amazon S3.

This is an update of http://github.com/RSpace/spree-heroku that works with Rails >= 3.0.3 and Spree >= 0.40.0

# Requirements 

A Heroku account and an Amazon S3 account with a bucket.

# Installation and configuration

Add this to your project Gemfile:

<pre>
gem 'spree_heroku', '1.0.0', :git => 'git://github.com/amedse/spree-heroku.git'
gem 'aws-s3'
</pre>

Install the new gems with bundler:
<pre>
bundle install
</pre>

Specify the S3 credentials via Heroku's environment variables:

<pre>
heroku config:add S3_KEY=[your S3 key]
heroku config:add S3_SECRET=[your S3 secret]
heroku config:add S3_BUCKET=[your S3 bucket]
</pre>

Create a Heroku application and deploy it:

<pre>
git init
git add .
git commit -m 'Initial create'
heroku create
git push heroku master
</pre>

Enable SSL, since Spree uses SSL for administration and payment flow in its standard setup:

<pre>
heroku addons:add "Piggyback SSL"
</pre>

Bootstrap the database locally (not possible in Heroku, because the rake task attempts to copy files), and transfer it to Heroku:

<pre>
rake db:bootstrap
heroku db:push
</pre>

Please note that if you choose to load sample data, images will be missing for all products. Spree's bootstrap task copies the images locally, but it doesn't put them on S3, where this extension configures Spree to look for images.

That's it - you're done! :)

# Troubleshooting

This extension has been tested with Spree 0.40.0 and Rails 3.0.3. If you have problems using the extension with a newer version of Spree, it could be due to Spree's gem dependencies having changed.

# Copyright and license

Copyright (c) 2011 Casper Fabricius, released under the New BSD License

Contributors:

*   Pavel Chipiga
*   Andrey Voronkov
*   Amed Rodriguez