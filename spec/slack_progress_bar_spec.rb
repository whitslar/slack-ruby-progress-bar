# frozen_string_literal: true

# include RSpec

describe SlackProgressBar do
  before(:each) do
    @progress_bar = SlackProgressBar.new(channel: 'foo', slack_token: 'bar')
  end

  describe 'Default Values' do
    it 'should have a default progress of 0' do
      expect(@progress_bar.progress).to eq(0)
    end
  end

  describe '.progress=' do
    it 'should set the progress' do
      @progress_bar.progress = 5
      expect(@progress_bar.progress).to eq(5)
    end

    it 'should return 0 if progress < 0' do
      @progress_bar.progress = -1
      expect(@progress_bar.progress).to eq(0)
    end

    it 'should return 100 if progress > 100' do
      @progress_bar.progress = 101
      expect(@progress_bar.progress).to eq(100)
    end
  end

  describe '.increment' do
    it 'should increment progress by 1' do
      @progress_bar.increment
      expect(@progress_bar.progress).to eq(1)
    end
  end

  describe '.decrement' do
    it 'should decrement progress by 1' do
      @progress_bar.progress = 5
      @progress_bar.decrement
      expect(@progress_bar.progress).to eq(4)
    end
  end

  describe '.rendered_bar' do
    subject { progress_bar.rendered_bar }

    context 'without bar emoji' do
      before do
        @progress_bar.instance_variable_set(:@bar_emoji, nil)
      end

      context 'with percentage' do
        before do
          @progress_bar.instance_variable_set(:@show_percent, true)
        end

        describe 'and 1% progress' do
          before { @progress_bar.progress = 1 }

          it { expect(@progress_bar.rendered_bar).to eq("\u2588 1%") }
        end
      end

      context 'without percentage' do
        before do
          @progress_bar.instance_variable_set(:@show_percent, false)
        end

        describe 'and 1% progress' do
          before { @progress_bar.progress = 1 }

          it { expect(@progress_bar.rendered_bar).to eq("\u2588") }
        end

        describe 'and 2% progress' do
          before { @progress_bar.progress = 2 }

          it { expect(@progress_bar.rendered_bar).to eq("\u2588") }
        end

        describe 'and 6% progress' do
          before { @progress_bar.progress = 6 }

          it { expect(@progress_bar.rendered_bar).to eq("\u2588\u2588") }
        end

        describe 'and 100% progress' do
          before { @progress_bar.progress = 100 }

          it { expect(@progress_bar.rendered_bar).to eq("\u2588" * 20) }
        end
      end
    end

    context 'with bar emoji' do
      before do
        @progress_bar.instance_variable_set(:@bar_emoji, "\u{1F600}")
      end

      context 'with percentage' do
        before do
          @progress_bar.instance_variable_set(:@show_percent, true)
        end

        describe 'and 1% progress' do
          before { @progress_bar.progress = 1 }

          it { expect(@progress_bar.rendered_bar).to eq("\u{2588} \u{1F600} 1%") }
        end
      end

      context 'without percentage' do
        before do
          @progress_bar.instance_variable_set(:@show_percent, false)
        end

        describe 'and 1% progress' do
          before { @progress_bar.progress = 1 }

          it { expect(@progress_bar.rendered_bar).to eq("\u2588 \u{1F600}") }
        end
      end
    end
  end
end
