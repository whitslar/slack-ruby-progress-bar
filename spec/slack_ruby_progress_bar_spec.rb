# frozen_string_literal: true
# rubocop:disable Style/StringLiterals

describe SlackRubyProgressBar do
  let(:progress_bar) { described_class.new(channel: 'foo', slack_token: 'bar', bar_color: :black) }

  before do
    allow(progress_bar).to receive(:post_to_slack).and_return(nil)
  end

  describe '.new' do
    it 'has a default progress of 0' do
      expect(progress_bar.progress).to eq(0)
    end
  end

  describe '.progress=' do
    it 'sets progress' do
      expect { progress_bar.progress = 5 }.to change(progress_bar, :progress).from(0).to(5)
    end

    it 'returns 0 if progress < 0' do
      progress_bar.progress = -1
      expect(progress_bar.progress).to eq(0)
    end

    it 'returns 100 if progress > 100' do
      progress_bar.progress = 101
      expect(progress_bar.progress).to eq(100)
    end

    it 'does not affect progress_text' do
      expect { progress_bar.progress = 10 }.to not_change(progress_bar, :progress_text)
    end

    it 'does not affect bar_color' do
      expect { progress_bar.progress = 10 }.to not_change(progress_bar, :bar_color)
    end
  end

  describe '.progress_text=' do
    it 'sets progress_text' do
      expect { progress_bar.progress_text = 'foo' }.to change(progress_bar, :progress_text).from('').to('foo')
    end

    it 'does not affect progress' do
      expect { progress_bar.progress_text = 'foo' }.to not_change(progress_bar, :progress)
    end

    it 'does not affect bar_color' do
      expect { progress_bar.progress_text = 'foo' }.to not_change(progress_bar, :bar_color)
    end
  end

  describe '.bar_color=' do
    it 'sets bar_color' do
      expect { progress_bar.bar_color = :blue }.to change(progress_bar, :bar_color).from(:black).to(:blue)
    end

    it 'does not affect progress' do
      expect { progress_bar.progress_text = 'foo' }.to not_change(progress_bar, :progress)
    end

    it 'does not affect progress_text' do
      expect { progress_bar.progress = 10 }.to not_change(progress_bar, :progress_text)
    end
  end

  describe '.increment' do
    it 'increments progress by 1' do
      expect { progress_bar.increment }.to change(progress_bar, :progress).from(0).to(1)
    end
  end

  describe '.decrement' do
    it 'decrements progress by 1' do
      progress_bar.progress = 5
      expect { progress_bar.decrement }.to change(progress_bar, :progress).from(5).to(4)
    end
  end

  describe '.finish' do
    it 'sets progress to 100' do
      expect { progress_bar.finish }.to change(progress_bar, :progress).from(0).to(100)
    end

    it 'sets progress_text to the elapsed time' do
      expect { progress_bar.finish }.to change(progress_bar, :progress_text)
        .to(a_string_matching(/Finished.*minutes|seconds/))
    end
  end

  describe '.clear' do
    before { progress_bar.update(progress: 5, progress_text: 'testing') }

    it 'clears progress and progress_text' do
      expect { progress_bar.clear }
        .to change(progress_bar, :progress).from(5).to(0)
        .and change(progress_bar, :progress_text).from('testing').to('')
    end
  end

  describe '.update' do
    before { progress_bar.update(progress: 55, progress_text: 'hello', bar_color: :purple) }

    it 'updates progress' do
      expect { progress_bar.update(progress: 5) }.to change(progress_bar, :progress).from(55).to(5)
    end

    it 'updates progress_text' do
      expect { progress_bar.update(progress_text: 'foo') }.to change(progress_bar, :progress_text).from('hello').to('foo')
    end

    it 'updates the bar color' do
      expect { progress_bar.update(bar_color: :red) }.to change(progress_bar, :bar_color).from(:purple).to(:red)
    end

    it 'updates progress, progress_text, and bar_color' do
      expect { progress_bar.update(progress: 25, progress_text: 'bar', bar_color: :yellow) }
        .to change(progress_bar, :progress).from(55).to(25)
        .and change(progress_bar, :progress_text).from('hello').to('bar')
        .and change(progress_bar, :bar_color).from(:purple).to(:yellow)
    end
  end

  describe '.rendered_bar' do
    subject { progress_bar.rendered_bar }

    context 'with percentage' do
      before do
        progress_bar.instance_variable_set(:@show_percent, true)
      end

      describe 'and 0% progress' do
        before { progress_bar.progress = 0 }

        it { is_expected.to eq("#{"⬜" * 10} 0%") }
      end

      describe 'and 1% progress' do
        before { progress_bar.progress = 1 }

        it { is_expected.to eq("#{"⬜" * 10} 1%") }
      end

      describe 'and 10% progress' do
        before { progress_bar.progress = 10 }

        it { is_expected.to eq("⬛#{"⬜" * 9} 10%") }
      end
    end

    context 'without percentage' do
      before do
        progress_bar.instance_variable_set(:@show_percent, false)
      end

      describe 'and 10% progress' do
        before { progress_bar.progress = 10 }

        it { is_expected.to eq("⬛#{"⬜" * 9}") }
      end

      describe 'and 11% progress' do
        before { progress_bar.progress = 11 }

        it { is_expected.to eq("⬛#{"⬜" * 9}") }
      end

      describe 'and 20% progress' do
        before { progress_bar.progress = 20 }

        it { is_expected.to eq(("⬛" * 2) + ("⬜" * 8)) }
      end

      describe 'and 100% progress' do
        before { progress_bar.progress = 100 }

        it { is_expected.to eq("⬛" * 10) }
      end
    end
  end
end
