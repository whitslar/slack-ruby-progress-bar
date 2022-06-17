# frozen_string_literal: true

require 'slack-ruby-client'

class SlackRubyProgressBar
  MIN_PROGRESS = 0
  MAX_PROGRESS = 100
  MAX_BAR_CHARACTERS = 10
  BAR_CHARACTER = "\u2588"

  BAR_CHARACTERS = {
    empty: "\u{2B1C}",
    black: "\u{2B1B}",
    green: "\u{1F7E9}",
    red: "\u{1F7E5}",
    orange: "\u{1F7E7}",
    yellow: "\u{1F7E8}",
    blue: "\u{1F7E6}",
    purple: "\u{1F7EA}",
    brown: "\u{1F7EB}"
  }.freeze

  attr_reader :progress, :progress_text

  def initialize(channel:, username: nil, icon_emoji: nil, icon_url: nil, slack_token: nil, show_percent: true, bar_color: :green)
    @slack_client = Slack::Web::Client.new(token: slack_token || ENV.fetch('SLACK_API_TOKEN', ''))
    @progress = MIN_PROGRESS
    @progress_text = ''
    @show_percent = show_percent
    @bar_color = bar_color
    @channel = channel
    @username = username
    @icon_emoji = icon_emoji
    @icon_url = icon_url
    @slack_message = nil
    @started_at = Time.now
  end

    @started_at ||= Time.now

    @progress = progress
    @progress = MIN_PROGRESS if @progress < MIN_PROGRESS
    @progress = MAX_PROGRESS if @progress > MAX_PROGRESS

    @progress_text = progress_text

    post_to_slack
  end

  def update_thread(message)
    @slack_client.chat_postMessage(channel: @channel, thread_ts: @slack_message.ts, text: message)
  end

  def increment
    update(progress: @progress + 1)
  end

  def decrement
    update(progress: @progress - 1)
  end

  def clear
    update(progress: MIN_PROGRESS, progress_text: '')
  end

  def finish
    update(progress: MAX_PROGRESS, progress_text: "Finished in #{formatted_elapsed_time}")
    @started_at = nil
  end

  def finished?
    @progress >= MAX_PROGRESS
  end

  def progress=(progress)
    update(progress: progress)
  end

  def progress_text=(progress_text)
    update(progress_text: progress_text)
  end

  def rendered_bar
    fill_count = ((@progress / MAX_PROGRESS.to_f) * MAX_PROGRESS).to_i / MAX_BAR_CHARACTERS
    empty_count = MAX_BAR_CHARACTERS - fill_count

    "#{bar_segment_filled * fill_count}#{bar_segment_empty * empty_count}" + percentage_text
  end

  def bar_segment_filled
    BAR_CHARACTERS[@bar_color.to_sym]
  end

  def bar_segment_empty
    BAR_CHARACTERS[:empty]
  end

  def percentage_text
    return '' unless @show_percent

    " #{@progress}%"
  end

  def formatted_progress_text
    return '' if @progress_text.strip.empty?

    "\n#{@progress_text}"
  end

  def elapsed_time
    Time.now - (@started_at || Time.now)
  end

  def formatted_elapsed_time
    elapsed_time > 300 ? "#{(elapsed_time / 60).round(2)} minutes" : "#{elapsed_time.round(2)} seconds"
  end

  def post_to_slack
    if @slack_message
      @slack_client.chat_update(channel: @slack_message.channel,
                                ts: @slack_message.ts,
                                text: rendered_bar + formatted_progress_text)
    else
      @slack_message = @slack_client.chat_postMessage(channel: @channel,
                                                      username: @username,
                                                      icon_url: @icon_url,
                                                      icon_emoji: @icon_emoji,
                                                      text: rendered_bar + formatted_progress_text)
    end
  end
end
