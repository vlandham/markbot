require 'twitter'
require 'marky_markov'

class Bot
  TEXT_DIR = File.join(File.expand_path(File.dirname(__FILE__)), "..", "text")
  TEXTS = ["hikes.txt", "mark_math.txt"]

  def initialize external_config = {}
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "3P2xQ1NgfamvgBIPpoZFXA"
      config.consumer_secret     = "bEaC6lvkjIkfvu4EURiz7IVb5B33qRCjoQhLN16Yg"
      config.access_token        = "1374775904-yZMKbSoicJ5n9yUIZ0oPYckMjp6WAc5gS9UMrGo"
      config.access_token_secret = "dJOgolcGE36YdUDrIRwZqtCzgHqrq6JzVRhpf8PW4zRqJ"
    end
  end

  def truncate(text, length = 30)
    l = text[0..length].rindex(" ")
    chars = text.chars.to_a
    if chars.length > length
      new_text = chars[0...l].join + "..."
    else
      new_text = text
    end

    return new_text
  end

  def end_at_punctuation(text)
    loc = text.rindex(/[.,?!]/)
    # if 80% of the text is before the
    # period, then truncate to the period
    if loc
      puts loc
      ratio = (loc) / text.length.to_f
      if ratio > 0.5
        text = text[0..loc]
      end
      if text[loc] == ","
        text[loc] = "."
      end
    end
    text
  end

  def load_markov
    @markov = MarkyMarkov::TemporaryDictionary.new
    dictonary = ""
    if rand() > 0.4
      dictonary = TEXTS[0]
    else
      dictonary = TEXTS[1]
    end
    @markov.parse_file File.join(TEXT_DIR, dictonary)

    # add some zappa
    if rand() < 0.2
      @markov.parse_file File.join(TEXT_DIR, "zappa.txt")
    end
    @markov
  end

  def create_sentences
    load_markov
    sentences = @markov.generate_30_sentences
    sentences = sentences.split(".")
    sentences = sentences.collect {|s| s + "."}
    sentences = sentences.keep_if {|s| s.length < 140}
    sentence = sentences.sample
    puts sentence

  end

  def create_tweet
    load_markov

    raw_text = @markov.generate_n_words 22
    tweet_text = end_at_punctuation(raw_text)
    if tweet_text.length > 140
      puts 'shortening'
      text_length = (110..135).to_a.sample
      tweet_text = truncate(raw_text, text_length)
    end
    puts tweet_text

    tweet_text
  end


  def tweet
    text = create_tweet
    new_tweet = @client.update(text)
    text
  end
end

# bot = Bot.new
# bot.create_tweet
