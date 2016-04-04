# EnchantedQuill

**EnchantedQuill** is a rubymotion port of [ActiveLabel.swift](https://github.com/optonaut/ActiveLabel.swift), just like the maintainer of that gem
I had also tried different `cocoapods` that were drop in replacements of `UILabel` but they were either a bit complex to implement or just doing too much. I decided to go with [ActiveLabel.swift](https://github.com/optonaut/ActiveLabel.swift) because its API is cleaner and simpler to implement and understand.

## Features
* Support for **Hashtags, Mentions, Categories and Links**
* Super easy to use and lightweight
* Acceptable test coverage :smile:

![Alt Text](https://github.com/paddingtonsbear/enchanted_quill/raw/master/example.gif)

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'enchanted_quill'
```

And then execute:

    $ bundle

## Usage

```ruby
label                         = EnchantedQuill::Label.alloc.init
label.text                    = text
label.textColor               = UIColor.blackColor
label.font                    = UIFont.systemFontOfSize(12)
label.mention_color           = UIColor.colorWithRed(85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1)
label.mention_selected_color  = UIColor.colorWithRed(85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1).colorWithAlphaComponent(0.5)
label.hashtag_color           = UIColor.colorWithRed(238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1)
label.hashtag_selected_color  = UIColor.colorWithRed(238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1).colorWithAlphaComponent(0.5)
label.category_color          = UIColor.brownColor
label.category_selected_color = UIColor.brownColor.colorWithAlphaComponent(0.5)
label.url_color               = UIColor.colorWithRed(85.0/255, green: 238.0/255, blue: 151.0/255, alpha: 1)
label.url_selected_color      = UIColor.colorWithRed(85.0/255, green: 238.0/255, blue: 151.0/255, alpha: 1).colorWithAlphaComponent(0.5)

# Handle Paragraph Styling
label.line_spacing            = 5
label.line_height_multiple    = 1.5
label.minimum_line_height     = 20
label.maximum_line_height     = 30

label.handle_mention_tap do |mention|
  p "Mention #{mention}"
end

label.handle_category_tap do |category|
  p "Category #{category}"
end

label.handle_url_tap do |url|
  p "URL #{url.absoluteString}"
end

label.handle_hashtag_tap do |hashtag|
  p "Hashtag #{hashtag}"
end
```
## Better Performance
For better performance use the `customize` block, this basically groups all customizations on the label
and refreshes the textContainer once instead of refreshing each time an attribute is set.
```ruby
label.customize do
  label.backgroundColor         = UIColor.blackColor
  label.text                    = text
  label.textColor               = UIColor.whiteColor
  label.font                    = UIFont.systemFontOfSize(12)
  label.numberOfLines           = 0
  label.mention_color           = UIColor.colorWithRed(85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1)
  label.mention_selected_color  = UIColor.colorWithRed(85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1).colorWithAlphaComponent(0.5)
  label.hashtag_color           = UIColor.colorWithRed(238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1)
  label.hashtag_selected_color  = UIColor.colorWithRed(238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1).colorWithAlphaComponent(0.5)
  label.category_color          = UIColor.brownColor
  label.category_selected_color = UIColor.brownColor.colorWithAlphaComponent(0.5)
  label.url_color               = UIColor.colorWithRed(85.0/255, green: 238.0/255, blue: 151.0/255, alpha: 1)
  label.url_selected_color      = UIColor.colorWithRed(85.0/255, green: 238.0/255, blue: 151.0/255, alpha: 1).colorWithAlphaComponent(0.5)

  label.handle_mention_tap do |mention|
    alert('Mention', mention)
  end

  label.handle_category_tap do |category|
    alert('Category', category)
  end

  label.handle_url_tap do |url|
    alert('URL', url.absoluteString)
  end

  label.handle_hashtag_tap do |hashtag|
    alert('HashTag', hashtag)
  end

  label.adjustsFontSizeToFitWidth = true
end
```


## Credits
A special thanks to [@optonaut](https://github.com/optonaut/ActiveLabel.swift) for implementing such an easy to use pod for swift. :+1:

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/paddingtonsbear/enchanted_quill. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
