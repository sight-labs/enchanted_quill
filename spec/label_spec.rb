describe 'EnchantedQuill::Label' do
  describe '#init' do
    it 'intializes like a UILabel' do
      label = UILabel.alloc.init
      label.class.should == UILabel
    end
  end

  describe '#initWithFrame' do
    it 'intializes like a UILabel' do
      label = UILabel.alloc.init
      label.class.should == UILabel
    end
  end
end
