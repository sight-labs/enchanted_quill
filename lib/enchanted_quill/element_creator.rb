module EnchantedQuill
  class ElementCreator
    Element = Struct.new(:type, :word, :range)

    def self.create_mentions_elements(text, range)
      mentions = EnchantedQuill::Parser.parse_elements_for(:mention, text, range)
      elements = []

      mentions.each do |mention|
        if mention.range.length > 2
          range = NSMakeRange(mention.range.location + 1, mention.range.length - 1)
          word  = text.substringWithRange(range)

          if word[0] == '@'
            word = word[1..-1]
          end

          elements << Element.new(:mention, word, range)
        end
      end

      elements
    end

    def self.create_hashtag_elements(text, range)
      hashtags = EnchantedQuill::Parser.parse_elements_for(:hashtag, text, range)
      elements = []

      hashtags.each do |hashtag|
        if hashtag.range.length > 2
          range = NSMakeRange(hashtag.range.location + 1, hashtag.range.length - 1)
          word  = text.substringWithRange(range)

          if word[0] == '#'
            word = word[1..-1]
          end

          elements << Element.new(:hashtag, word, range)
        end
      end

      elements
    end

    def self.create_category_elements(text, range)
      categories = EnchantedQuill::Parser.parse_elements_for(:category, text, range)
      elements = []

      categories.each do |category|
        if category.range.length > 2
          range = NSMakeRange(category.range.location + 1, category.range.length - 1)
          word  = text.substringWithRange(range)

          if word[0] == '{' && word[-1] == '}'
            word = word[1..-2]
          end

          elements << Element.new(:category, word, range)
        end
      end

      elements
    end

    def self.create_url_elements(text, range)
      urls     = EnchantedQuill::Parser.parse_elements_for(:url, text, range)
      elements = []

      urls.each do |url|
        if url.range.length > 2
          word  = text.substringWithRange(url.range)
            .stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

          elements << Element.new(:url, word, range)
        end
      end

      elements
    end
  end
end
