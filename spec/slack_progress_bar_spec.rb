# frozen_string_literal: true

describe SlackProgressBar do
  before(:each) do
    @progress_bar = SlackProgressBar.new(channel: 'foo', slack_token: 'bar', bar_color: :black)
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

    it 'should not affect progress_text' do
      @progress_bar.progress_text = 'foo'
      expect { @progress_bar.progress = 10 }.to not_change { @progress_bar.progress_text }
    end
  end

  describe '.progress_text=' do
    it 'should set the progress_text' do
      @progress_bar.progress_text = 'foo'
      expect(@progress_bar.progress_text).to eq('foo')
    end

    it 'should not affect progress' do
      @progress_bar.progress = 10
      expect { @progress_bar.progress_text = 'foo' }.to not_change { @progress_bar.progress }
    end
  end

  describe '.increment' do
    it 'should increment progress by 1' do
      expect { @progress_bar.increment }.to change { @progress_bar.progress }.from(0).to(1)
    end
  end

  describe '.decrement' do
    it 'should decrement progress by 1' do
      @progress_bar.progress = 5
      expect { @progress_bar.decrement }.to change { @progress_bar.progress }.from(5).to(4)
    end
  end

  describe '.finish' do
    it 'should set progress to 100' do
      expect { @progress_bar.finish }
        .to change { @progress_bar.progress }.from(0).to(100)
        .and change { @progress_bar.progress_text }
    end
  end

  describe '.clear' do
    it 'should clear the progress and progress_text' do
      @progress_bar.update(progress: 5, progress_text: 'testing')

      expect { @progress_bar.clear }
        .to change { @progress_bar.progress }.from(5).to(0)
        .and change { @progress_bar.progress_text }.from('testing').to('')
    end
  end

  describe '.rendered_bar' do
    subject { progress_bar.rendered_bar }

    context 'with percentage' do
      before do
        @progress_bar.instance_variable_set(:@show_percent, true)
      end

      describe 'and 0% progress' do
        before { @progress_bar.progress = 0 }

        it { expect(@progress_bar.rendered_bar).to eq("\u{2B1C}" * 10 + " 0%") }
      end

      describe 'and 1% progress' do
        before { @progress_bar.progress = 1 }

        it { expect(@progress_bar.rendered_bar).to eq("\u{2B1C}" * 10 + " 1%") }
      end

      describe 'and 10% progress' do
        before { @progress_bar.progress = 10 }

        it { expect(@progress_bar.rendered_bar).to eq("\u{2B1B}" + "\u{2B1C}" * 9 + " 10%") }
      end
    end

    context 'without percentage' do
      before do
        @progress_bar.instance_variable_set(:@show_percent, false)
      end

      describe 'and 10% progress' do
        before { @progress_bar.progress = 10 }

        it { expect(@progress_bar.rendered_bar).to eq("\u{2B1B}" + "\u{2B1C}" * 9) }
      end

      describe 'and 11% progress' do
        before { @progress_bar.progress = 11 }

        it { expect(@progress_bar.rendered_bar).to eq("\u{2B1B}" + "\u{2B1C}" * 9) }
      end

      describe 'and 20% progress' do
        before { @progress_bar.progress = 20 }

        it { expect(@progress_bar.rendered_bar).to eq("\u{2B1B}" * 2 + "\u{2B1C}" * 8) }
      end

      describe 'and 100% progress' do
        before { @progress_bar.progress = 100 }

        it { expect(@progress_bar.rendered_bar).to eq("\u{2B1B}" * 10) }
      end
    end
  end
end
