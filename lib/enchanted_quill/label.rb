module EnchantedQuill
  class Label < UILabel
    attr_reader :mention_tap_handler, :url_tap_handler, :hashtag_tap_handler,
                :category_tap_handler, :mention_color, :mention_selected_color,
                :hashtag_color, :hashtag_selected_color, :category_color,
                :category_selected_color, :url_color, :url_selected_color,
                :line_spacing, :line_height_multiple, :minimum_line_height,
                :maximum_line_height

    def init
      super.tap do |label|
        label.setup_label
      end
    end

    def initWithFrame(frame)
      super.tap do |label|
        label.setup_label
      end
    end

    def awakeFromNib
      super.tap do
        update_text_storage
      end
    end

    def drawTextInRect(rect)
      range               = NSMakeRange(0, text_storage.length)
      text_container.size = rect.size
      new_origin          = text_origin(rect)

      layout_manager.drawBackgroundForGlyphRange(range, atPoint: new_origin)
      layout_manager.drawGlyphsForGlyphRange(range, atPoint: new_origin)
    end

    def layoutSubviews
      super
      text_container.size = self.bounds.size
    end

    def setPreferredMaxLayoutWidth(preferred_max_layout_width)
      super
      update_text_container_size(self.bounds.size)
    end

    def setFrame(frame)
      super
      update_text_container_size(frame.size)
    end

    def setBounds(bounds)
      super
      update_text_container_size(bounds.size)
    end

    def update_text_container_size(size)
	    container_size = size
	    width  = [size.width, self.preferredMaxLayoutWidth].min
      height = 0
	    text_container.size = CGSizeMake(width, height)
    end


    # Override UILabel Methods
    def textRectForBounds(bounds, limitedToNumberOfLines: num_of_lines)
	    required_rect = rect_fitting_text_for_container_size(bounds.size, for_number_of_line: num_of_lines)
	    text_container.size = required_rect.size
	    required_rect
    end

    def rect_fitting_text_for_container_size(size, for_number_of_line: num_of_lines)
      text_container.size = size;
      text_container.maximumNumberOfLines = num_of_lines
      text_bounds = layout_manager.boundingRectForGlyphRange(NSMakeRange(0, layout_manager.numberOfGlyphs),
                      inTextContainer: text_container)
      total_lines = text_bounds.size.height / self.font.lineHeight

      height = text_bounds.size.height
      if num_of_lines > 0 && (num_of_lines < total_lines)
        height -= (total_lines - num_of_lines) * self.font.lineHeight
      elsif (num_of_lines > 0 && (num_of_lines > total_lines))
        height += (num_of_lines - total_lines) * self.font.lineHeight
      end

      width  = text_bounds.size.width.ceil
      height = (attributedText && attributedText.mutableString.blank?) ? 0 : height.ceil
      CGRectMake(text_bounds.origin.x, text_bounds.origin.y, width, height)
    end

    # Override UIView methods
    def requiresConstraintBasedLayout
      true
    end

    def customize(&block)
      @customizing = true
      block.call(self)
      @customizing = false
      update_text_storage
      self
    end

    def on_touch(touch)
      location = touch.locationInView(self)
      avoid_super_call = false

      case touch.phase
      when UITouchPhaseBegan, UITouchPhaseMoved
        if element = element_at_location(location)
          if element.range.location != (selected_element && selected_element.range.location) ||
             element.range.length != (selected_element && selected_element.range.length)

             update_attributed_when_selected(false)
             @selected_element = element
             update_attributed_when_selected(true)
           end
           avoid_super_call = true
        else
          update_attributed_when_selected(false)
          @selected_element = nil
        end
      when UITouchPhaseEnded
        return avoid_super_call unless selected_element

        case selected_element.type
        when :category then did_tap_category(selected_element.word)
        when :mention  then did_tap_mention(selected_element.word)
        when :hashtag  then did_tap_hashtag(selected_element.word)
        when :url      then did_tap_string_url(selected_element.word)
        else
        end

        Dispatch::Queue.concurrent.after(0.1) do
          Dispatch::Queue.main.async do
            update_attributed_when_selected(false)
            @selected_element = nil
          end
        end
        avoid_super_call = true
      when UITouchPhaseCancelled
        Dispatch::Queue.concurrent.after(0.1) do
          Dispatch::Queue.main.async do
            update_attributed_when_selected(false)
            @selected_element = nil
          end
        end
      when UITouchPhaseStationary
      end

      avoid_super_call
    end

    def delegate=(delegate)
      @delegate = WeakRef.new(delegate)
    end

    def delegate
      @delegate
    end

    def handle_mention_tap(&block)
      @mention_tap_handler = block
    end

    def handle_hashtag_tap(&block)
      @hashtag_tap_handler = block
    end

    def handle_url_tap(&block)
      @url_tap_handler = block
    end

    def handle_category_tap(&block)
      @category_tap_handler = block
    end

    # override UILabel attributes
    def text=(text)
      super
      update_text_storage
    end

    def attributedText=(attributed_text)
      super
      update_text_storage
    end

    def font=(font)
      super
      update_text_storage(false)
    end

    def textColor=(color)
      super
      update_text_storage(false)
    end

    def textAlignment=(alignment)
      super
      update_text_storage(false)
    end

    def mention_color=(color)
      @mention_color = color
      update_text_storage(false)
    end

    def mention_selected_color=(color)
      @mention_selected_color = color
      update_text_storage(false)
    end

    def hashtag_color=(color)
      @hashtag_color = color
      update_text_storage(false)
    end

    def hashtag_selected_color=(color)
      @hashtag_selected_color = color
      update_text_storage(false)
    end

    def category_color=(color)
      @category_color = color
      update_text_storage(false)
    end

    def category_selected_color=(color)
      @category_selected_color = color
      update_text_storage(false)
    end

    def url_color=(color)
      @url_color = color
      update_text_storage(false)
    end

    def url_selected_color=(color)
      @url_selected_color = color
      update_text_storage(false)
    end

    def line_spacing=(spacing)
      @line_spacing = spacing
      update_text_storage(false)
    end

    def line_height_multiple=(multiple)
      @line_height_multiple = multiple
      update_text_storage(false)
    end

    def maximum_line_height=(height)
      @maximum_line_height = height
      update_text_storage(false)
    end

    def minimum_line_height=(height)
      @minimum_line_height = height
      update_text_storage(false)
    end

    def touchesBegan(touches, withEvent: event)
      touches = touches && touches.allObjects
      touch   = touches.first
      return unless touch
      return if on_touch(touch)
      super
    end

    def touchesCancelled(touches, withEvent: event)
      touches = touches && touches.allObjects
      touch   = touches.first
      return unless touch
      on_touch(touch)
      super
    end

    def touchesEnded(touches, withEvent: event)
      touches = touches && touches.allObjects
      touch   = touches.first
      return unless touch
      return if on_touch(touch)
      super
    end

    def setup_label
      @setup_label ||= begin
        @customizing = false
        @active_elements = {}
        @height_correction = 0
        self.line_height_multiple    = 1
        self.textColor               = UIColor.blackColor
        self.mention_color           = UIColor.blueColor
        self.mention_selected_color  = UIColor.blueColor.colorWithAlphaComponent(0.5)
        self.hashtag_color           = UIColor.blueColor
        self.hashtag_selected_color  = UIColor.blueColor.colorWithAlphaComponent(0.5)
        self.category_color          = UIColor.brownColor
        self.category_selected_color = UIColor.brownColor.colorWithAlphaComponent(0.5)
        self.url_color               = UIColor.blueColor
        self.url_selected_color      = UIColor.blueColor.colorWithAlphaComponent(0.5)

        text_storage.addLayoutManager(layout_manager)
        layout_manager.addTextContainer(text_container)
        text_container.lineFragmentPadding = 0
        text_container.maximumNumberOfLines = 0
        self.userInteractionEnabled = true
      end
    end

    private

    attr_reader :customizing, :selected_element, :mention_tap_handler,
                :url_tap_handler, :hashtag_tap_handler, :category_tap_handler,
                :height_correction, :active_elements

    def layout_manager
      @layout_manager ||= NSLayoutManager.alloc.init
    end

    def text_container
      @text_container ||= NSTextContainer.alloc.init
    end

    def text_storage
      @text_storage ||= NSTextStorage.alloc.init
    end

    def update_text_storage(parse_text = true)
      return if customizing

      attributed_text = attributedText
      if attributed_text.nil? || attributed_text.length == 0
        clear_active_elements
        text_storage.setAttributedString(NSAttributedString.alloc.initWithString(''))
        setNeedsDisplay
        return
      end

      mut_attr_string = add_line_break(attributed_text)
      mut_attr_string = add_default_attributes(mut_attr_string)

      if parse_text
        clear_active_elements
        parse_text_and_extract_active_elements(mut_attr_string)
        active_elements_values = @active_elements.values.flatten.compact

        if active_elements_values.count > 0
          add_link_attribute(mut_attr_string)
          text_storage.setAttributedString(mut_attr_string)
          setNeedsDisplay
        end
      end

      text_storage.setAttributedString(mut_attr_string)
      setNeedsDisplay
    end

    def clear_active_elements
      @selected_element = nil
      @active_elements  = {}
    end

    def text_origin(rect)
      used_rect          = layout_manager.usedRectForTextContainer(text_container)
      @height_correction = (rect.size.height - used_rect.size.height) / 2
      glyph_origin_y     = height_correction > 0 ? rect.origin.y + height_correction : rect.origin.y
      CGPointMake(rect.origin.x, glyph_origin_y)
    end

    def add_default_attributes(mut_attr_string)
      range_pointer = Pointer.new(NSRange.type)
      attributes = mut_attr_string.attributesAtIndex(0, effectiveRange: range_pointer).dup

      attributes[NSFontAttributeName] = self.font
      attributes[NSForegroundColorAttributeName] = self.textColor

      mut_attr_string.addAttributes(attributes, range: range_pointer[0])
      mut_attr_string
    end

    # add link attribute
    def add_link_attribute(mut_attr_string)
      range_pointer = Pointer.new(NSRange.type)
      attributes = mut_attr_string.attributesAtIndex(0, effectiveRange: range_pointer).dup

      attributes[NSFontAttributeName] = self.font
      attributes[NSForegroundColorAttributeName] = self.textColor
      mut_attr_string.addAttributes(attributes, range: range_pointer[0])

      active_elements.each do |type, elements|
        case type
        when :mention  then attributes[NSForegroundColorAttributeName] = mention_color
        when :hashtag  then attributes[NSForegroundColorAttributeName] = hashtag_color
        when :url      then attributes[NSForegroundColorAttributeName] = url_color
        when :category then attributes[NSForegroundColorAttributeName] = category_color
        end

        elements.each do |element|
          mut_attr_string.setAttributes(attributes, range: element.range)
        end
      end
    end

    def parse_text_and_extract_active_elements(attr_string)
      text_string = attr_string.string
      text_length = text_string.length
      text_range  = NSMakeRange(0, text_length)

      # urls
      url_elements = ElementCreator.create_url_elements(text_string, text_range)
      @active_elements[:url] = url_elements

      # hash_tags
      hashtag_elements = ElementCreator.create_hashtag_elements(text_string, text_range)
      @active_elements[:hashtag] = hashtag_elements

      # mentions
      mention_elements = ElementCreator.create_mentions_elements(text_string, text_range)
      @active_elements[:mention] = mention_elements

      # categories
      category_elements = ElementCreator.create_category_elements(text_string, text_range)
      @active_elements[:category] = category_elements
    end

    def add_line_break(attr_string)
      mut_attr_string = NSMutableAttributedString.alloc.initWithAttributedString(attr_string)

      range_pointer = Pointer.new(NSRange.type)
      attributes = mut_attr_string.attributesAtIndex(0, effectiveRange: range_pointer).dup

      current_paragraph_style = attributes[NSParagraphStyleAttributeName] && attributes[NSParagraphStyleAttributeName].mutableCopy
      paragraph_style = current_paragraph_style || NSMutableParagraphStyle.alloc.init
      paragraph_style.lineBreakMode      = NSLineBreakByWordWrapping
      paragraph_style.alignment          = textAlignment
      paragraph_style.lineSpacing        = line_spacing if line_spacing
      paragraph_style.lineHeightMultiple = line_height_multiple

      paragraph_style.minimumLineHeight = if minimum_line_height && minimum_line_height > 0
                                            minimum_line_height
                                          else
                                            font.lineHeight * line_height_multiple
                                          end

      paragraph_style.maximumLineHeight = if maximum_line_height and maximum_line_height > 0
                                            maximum_line_height
                                          else
                                            font.lineHeight * line_height_multiple
                                          end

      attributes[NSParagraphStyleAttributeName] = paragraph_style
      mut_attr_string.setAttributes(attributes, range: range_pointer[0])
      mut_attr_string
    end

    def update_attributed_when_selected(selected)
      return unless @selected_element

      attributes = text_storage.attributesAtIndex(0, effectiveRange: nil).dup
      unless selected
        case @selected_element.type
        when :category then attributes[NSForegroundColorAttributeName] = category_color
        when :hashtag  then attributes[NSForegroundColorAttributeName] = hashtag_color
        when :mention  then attributes[NSForegroundColorAttributeName] = mention_color
        when :url      then attributes[NSForegroundColorAttributeName] = url_color
        end
      else
        case @selected_element.type
        when :category then attributes[NSForegroundColorAttributeName] = category_selected_color || category_color
        when :hashtag  then attributes[NSForegroundColorAttributeName] = hashtag_selected_color  || hashtag_color
        when :mention  then attributes[NSForegroundColorAttributeName] = mention_selected_color  || mention_color
        when :url      then attributes[NSForegroundColorAttributeName] = url_selected_color      || url_color
        end
      end

      text_storage.addAttributes(attributes, range: @selected_element.range)
      setNeedsDisplay
    end

    def element_at_location(location)
      return unless text_storage.length > 0

      y = location.y - height_correction
      correct_location = CGPointMake(location.x, y)
      bounding_rect    = layout_manager.boundingRectForGlyphRange(NSMakeRange(0, text_storage.length), inTextContainer: text_container)

      return unless CGRectContainsPoint(bounding_rect, correct_location)

      index = layout_manager.glyphIndexForPoint(correct_location, inTextContainer: text_container)

      active_element = nil
      active_elements.values.flatten.each do |element|
        if index < text_storage.length - 1 &&
           index >= element.range.location &&
           index < element.range.location + element.range.length
          active_element = element
          break
        end
      end

      active_element
    end

    def did_tap_mention(username)
      if mention_tap_handler
        mention_tap_handler.call(username)
      elsif delegate && delegate.respond_to?('did_select_text:type:')
        delegate.did_select_text(username, type: :mention)
      end
    end

    def did_tap_hashtag(hashtag)
      if hashtag_tap_handler
        hashtag_tap_handler.call(hashtag)
      elsif delegate && delegate.respond_to?('did_select_text:type:')
        delegate.did_select_text(hashtag, type: :hashtag)
      end
    end

    def did_tap_string_url(url)
      url = NSURL.URLWithString(url)
      if url_tap_handler
        url_tap_handler.call(url)
      elsif delegate && delegate.respond_to?('did_select_text:type:')
        delegate.did_select_text(url, type: :url)
      end
    end

    def did_tap_category(category)
      if category_tap_handler
        category_tap_handler.call(category)
      elsif delegate && delegate.respond_to?('did_select_text:type:')
        delegate.did_select_text(category, type: :category)
      end
    end
  end
end
