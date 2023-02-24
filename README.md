# Automatic1111 Ruby API Wrapper

This is a Ruby client for the [automatic1111](https://replicate.com/) Stable
Diffusion WebUI.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'automatic1111'
```

## Usage

```ruby
# Setup client
client = Automatic1111::Client.new(api_endpoint_url: '<http://127.0.0.1:7860 or
https://xxxxxx.gradio.live')

# Authenticate
client.post('/login', params: { username: 'username', password: 'password' }, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })

# Call endpoint
resp = client.post('/sdapi/v1/txt2img', params: { prompt: 'test', sampler_name: 'DPM++ SDE Karras', steps: 20, enable_hr: true, hr_upscaler: 'Latent', denoising_strength: 0.7, width: 512, height: 768 })
resp['images']
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).
