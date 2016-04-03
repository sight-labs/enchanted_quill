describe 'EnchantedQuill::ElementCreator' do
  describe '.create_mentions_elements' do
    it 'returns an empty array if no mention elements created' do
      text  = 'dumbledore is a genius'
      range = NSMakeRange(0, text.length)

      mentions = EnchantedQuill::ElementCreator.create_mentions_elements(text, range)
      mentions.should.be.empty
    end

    it 'returns an array of elements if mention elements created' do
      text  = 'plot twist, @dumbledore, @harry_potter and @snape are the bad guys'
      range = NSMakeRange(0, text.length)

      mentions = EnchantedQuill::ElementCreator.create_mentions_elements(text, range)
      mentions.should.not.be.empty

      mentions.map(&:class).uniq.should == [EnchantedQuill::ElementCreator::Element]
      mentions.map(&:type).uniq.should == [:mention]
      mentions.map(&:word).uniq.should == ['dumbledore', 'harry_potter', 'snape']
      mentions.map(&:range).uniq.should.not.be.empty
    end
  end

  describe '.create_hashtag_elements' do
    it 'returns an empty array if no hashtag elements created' do
      text  = 'dumbledore is a genius'
      range = NSMakeRange(0, text.length)

      mentions = EnchantedQuill::ElementCreator.create_mentions_elements(text, range)
      mentions.should.be.empty
    end

    it 'returns an array of elements if hashtag elements created' do
      text  = 'plot twist, #dumbledore, #harry_potter and #snape are the bad guys'
      range = NSMakeRange(0, text.length)

      mentions = EnchantedQuill::ElementCreator.create_hashtag_elements(text, range)
      mentions.should.not.be.empty

      mentions.map(&:class).uniq.should == [EnchantedQuill::ElementCreator::Element]
      mentions.map(&:type).uniq.should == [:hashtag]
      mentions.map(&:word).uniq.should == ['dumbledore', 'harry_potter', 'snape']
      mentions.map(&:range).uniq.should.not.be.empty
    end
  end

  describe '.create_category_elements' do
    it 'returns an empty array if no hashtag elements created' do
      text  = 'dumbledore is a genius'
      range = NSMakeRange(0, text.length)

      mentions = EnchantedQuill::ElementCreator.create_mentions_elements(text, range)
      mentions.should.be.empty
    end

    it 'returns an array of elements if hashtag elements created' do
      text  = 'plot twist, {dumbledore}, {harry_potter} and {snape} are the bad guys'
      range = NSMakeRange(0, text.length)

      mentions = EnchantedQuill::ElementCreator.create_category_elements(text, range)
      mentions.should.not.be.empty

      mentions.map(&:class).uniq.should == [EnchantedQuill::ElementCreator::Element]
      mentions.map(&:type).uniq.should == [:category]
      mentions.map(&:word).uniq.should == ['dumbledore', 'harry_potter', 'snape']
      mentions.map(&:range).uniq.should.not.be.empty
    end
  end

  describe '.create_url_elements' do
    it 'returns an empty array if no hashtag elements created' do
      text  = 'dumbledore is a genius'
      range = NSMakeRange(0, text.length)

      mentions = EnchantedQuill::ElementCreator.create_mentions_elements(text, range)
      mentions.should.be.empty
    end

    it 'returns an array of elements if hashtag elements created' do
      text  = 'plot twist, I visited http://www.google.com and www.google.io'
      range = NSMakeRange(0, text.length)

      mentions = EnchantedQuill::ElementCreator.create_url_elements(text, range)
      mentions.should.not.be.empty

      mentions.map(&:class).uniq.should == [EnchantedQuill::ElementCreator::Element]
      mentions.map(&:type).uniq.should == [:url]
      mentions.map(&:word).uniq.should == ['http://www.google.com', 'www.google.io']
      mentions.map(&:range).uniq.should.not.be.empty
    end
  end
end
