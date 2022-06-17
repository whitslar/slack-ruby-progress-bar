# SlackRubyProgressBar
![](https://github.com/whitslar/slack-ruby-progress-bar/blob/master/slack-ruby-progress-bar.gif)

A Slack progress bar for Ruby.


Inspired by: https://github.com/bcicen/slack-progress

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slack-ruby-progress-bar'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install slack-ruby-progress-bar

## Usage

```ruby
progress_bar = SlackRubyProgressBar.new(channel: '#some-channel', username: 'some-username', slack_token: 'some-token', bar_color: 'blue')
progress_bar.update(progress: 1)
progress_bar.update(progress_text: 'one percent complete')
progress_bar.update(progress: 10, progress_text: 'ten percent complete')
progress_bar.increment
progress_bar.clear
progress_bar.finish
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/whitslar/slack-ruby-progress-bar. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/whitslar/slack-ruby-progress-bar/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SlackRubyProgressBar project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/whitslar/slack-ruby-progress-bar/blob/master/CODE_OF_CONDUCT.md).
