# frozen_string_literal: true

require 'slack-ruby-client'

class SlackProgressBar
  MIN_PROGRESS = 0
  MAX_PROGRESS = 100
  BAR_CHARACTER = "\u2588"

  attr_reader :progress, :progress_text

  def initialize(channel:, username: nil, icon_emoji: nil, icon_url: nil, slack_token: nil, bar_emoji: nil, bar_character: BAR_CHARACTER, show_percent: true)
    @slack_client = Slack::Web::Client.new(token: slack_token || ENV.fetch('SLACK_API_TOKEN'))
    @progress = MIN_PROGRESS
    @progress_text = ''
    @channel = channel
    @username = username
    @icon_emoji = icon_emoji
    @icon_url = icon_url
    @bar_emoji = bar_emoji
    @bar_character = bar_character.encode('utf-8')
    @slack_message = nil
    @show_percent = true
  end

  def update(progress: nil, progress_text: '')
    @progress = progress
    @progress = MIN_PROGRESS if @progress < MIN_PROGRESS
    @progress = MAX_PROGRESS if @progress > MAX_PROGRESS

    @progress_text = progress_text
    @progress_text = ' ' + @progress_text unless @progress_text.empty?

    # post_to_slack
  end

  def update_thread(message)
    @slack_client.chat_postMessage(channel: @channel, thread_ts: @slack_message.ts, text: message)
  end

  def increment
    self.progress += 1
  end

  def decrement
    self.progress -= 1
  end

  def progress=(progress)
    update(progress: progress)
  end

  def progress_text=(progress_text)
    update(progress_text: progress_text)
  end

  def rendered_bar
    "#{ @bar_character * (@progress / 5.0).ceil }" + bar_emoji + percent_text
  end

  def bar_emoji
    return '' unless @bar_emoji && @progress < 100

    " #{@bar_emoji}"
  end

  def percent_text
    return '' unless @show_percent

    " #{@progress}%"
  end

  def post_to_slack
    if @slack_message
      @slack_client.chat_update(channel: @slack_message.channel, ts: @slack_message.ts, text: progress_bar + @progress_text)
    else
      @slack_message = @slack_client.chat_postMessage(channel: @channel,
                                                      username: @username,
                                                      icon_url: @icon_url,
                                                      icon_emoji: @icon_emoji,
                                                      text: progress_bar + @progress_text)
    end
  end
end
