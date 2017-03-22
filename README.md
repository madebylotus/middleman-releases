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


## Configuration
Configuration options can be defined in your `config.rb` file.

```ruby
activate :releases do |releases|
  # releases.layout = 'custom_layout'
end
```
