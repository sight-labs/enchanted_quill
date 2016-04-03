module EnchantedQuill
  class Parser
    CATEGORY_REGEX = "(?:^|\\s|$)(\\{.*?\\})"
    HASHTAG_REGEX  = "(?:^|\\s|$)#[\\p{L}0-9_]*"
    MENTION_REGEX  = "(?:^|\\s|$|[.])@[\\p{L}0-9_]*"
    URL_REGEX      = "(^|[\\s.:;?\\-\\]<\\(])" +
                     "((https?://|www.|pic.)[-\\w;/?:@&=+$\\|\\_.!~*\\|'()\\[\\]%#,☺]+[\\w/#](\\(\\))?)" +
                     "(?=$|[\\s',\\|\\(\\).:;?\\-\\[\\]>\\)])"

    TYPE_WITH_REGEX = {
      url:      URL_REGEX,
      hashtag:  HASHTAG_REGEX,
      mention:  MENTION_REGEX,
      category: CATEGORY_REGEX
    }

    def self.parse_elements_for(type, text, range)
      regex = TYPE_WITH_REGEX[type]
      return [] unless regex

      regex = NSRegularExpression.alloc.initWithPattern(regex, options: NSRegularExpressionCaseInsensitive, error: nil)
      regex.matchesInString(text, options: 0, range: range)
    end
  end
end
