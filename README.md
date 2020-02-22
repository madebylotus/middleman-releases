# middleman-releases

Manage a directory of software releases in your project.

## Installation

Add the gem to your Gemfile:

```ruby
gem 'middleman-releases'
```

Then run bundle.

```
$> bundle install
```

## Usage
In your template file, you can optionally access a release instance using the helper method.

```slim
= current_release.title
```

## Generate New Software Release
This gem includes a CLI command to generate a new software release from a template file.

```shell
# Sets the date and git tag of the release, opens for editing immediately
$> bundle exec middleman release v4.0.0 --date "2017-04-01 17:00pm EST" --edit
```


## Configuration
Configuration options can be defined in your `config.rb` file.

```ruby
activate :releases do |releases|
  # releases.layout = 'custom_layout'
  # releases.releases_dir = 'releases'
  # releases.new_release_template = File.expand_path('../custom_template.tt', __FILE__)
end
```

If your date frontmatter includes timestamps, you should also ensure a
`Time.zone` is being set in your `config.rb`:

```ruby
Time.zone = 'America/New_York'
```
