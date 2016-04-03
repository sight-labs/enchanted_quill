describe 'EnchantedQuill::Parser' do
  describe '.parse_elements_for' do
    it 'returns an empty array if passed an invalid type' do
      text  = 'some text'
      range = NSMakeRange(0, text.length)
      elements = EnchantedQuill::Parser.parse_elements_for(:invalid, 'some text', range)
      elements.should == []
    end

    context 'url elements' do
      it 'returns an empty array if no url matches found' do
        text  = 'dumbledore is a genius'
        range = NSMakeRange(0, text.length)
        elements = EnchantedQuill::Parser.parse_elements_for(:category, text, range)
        elements.should == []
      end

      [ 'www.google.com',
        'http://www.google.com',
        'https://www.google.com',
        'www.google.io',
        'www.google.drop'
      ].each do |text|
        it 'returns an array of matches found' do
          range = NSMakeRange(0, text.length)
          elements = EnchantedQuill::Parser.parse_elements_for(:url, text, range)
          elements.should.not.be.empty
        end
      end
    end

    describe 'category elements' do
      it 'returns an empty array if no hashtag matches found' do
        text  = 'dumbledore is a genius'
        range = NSMakeRange(0, text.length)
        elements = EnchantedQuill::Parser.parse_elements_for(:category, text, range)
        elements.should == []
      end

      { '{dumbledore} is a genius' => ['{dumbledore}'],
        '{harry_potter} did not kill voldemort' => ['{harry_potter}'],
        '{dumbledore}, {harry_potter} and {voldemort} are at the Shrieking Shack' => ['{dumbledore}', '{harry_potter}', '{voldemort}']
      }.each do |text, matches|
        it 'returns an array of matches found' do
          range = NSMakeRange(0, text.length)
          elements = EnchantedQuill::Parser.parse_elements_for(:category, text, range)
          elements.should.not.be.empty

          expected_matches = []
          elements.each do |element|
            range = NSMakeRange(element.range.location, element.range.length)
            expected_matches << text.substringWithRange(range).strip
          end

          expected_matches.should == matches
        end
      end
    end

    describe 'hashtag elements' do
      it 'returns an empty array if no hashtag matches found' do
        text  = 'dumbledore is a genius'
        range = NSMakeRange(0, text.length)
        elements = EnchantedQuill::Parser.parse_elements_for(:hashtag, text, range)
        elements.should == []
      end

      { '#dumbledore is a genius' => ['#dumbledore'],
        '#harry_potter did not kill voldemort' => ['#harry_potter'],
        '#dumbledore, #harry_potter and #voldemort are at the Shrieking Shack' => ['#dumbledore', '#harry_potter', '#voldemort']
      }.each do |text, matches|
        it 'returns an array of matches found' do
          range = NSMakeRange(0, text.length)
          elements = EnchantedQuill::Parser.parse_elements_for(:hashtag, text, range)
          elements.should.not.be.empty

          expected_matches = []
          elements.each do |element|
            range = NSMakeRange(element.range.location, element.range.length)
            expected_matches << text.substringWithRange(range).strip
          end

          expected_matches.should == matches
        end
      end
    end

    describe 'mentions elements' do
      it 'returns an empty array if no mention matches found' do
        text  = 'dumbledore is a genius'
        range = NSMakeRange(0, text.length)
        elements = EnchantedQuill::Parser.parse_elements_for(:mention, text, range)
        elements.should == []
      end

      { '@dumbledore is a genius' => ['@dumbledore'],
        '@harry_potter did not kill voldemort' => ['@harry_potter'],
        '@dumbledore, @harry_potter and @voldemort are at the Shrieking Shack' => ['@dumbledore', '@harry_potter', '@voldemort']
      }.each do |text, matches|
        it 'returns an array of matches found' do
          range = NSMakeRange(0, text.length)
          elements = EnchantedQuill::Parser.parse_elements_for(:mention, text, range)
          elements.should.not.be.empty

          expected_matches = []
          elements.each do |element|
            range = NSMakeRange(element.range.location, element.range.length)
            expected_matches << text.substringWithRange(range).strip
          end

          expected_matches.should == matches
        end
      end
    end
  end
end
