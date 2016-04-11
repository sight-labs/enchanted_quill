class AppDelegate
  attr_reader :window

  def application(application, didFinishLaunchingWithOptions:launch_options)
    return true if RUBYMOTION_ENV == 'test'

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = TestLabelViewController.alloc.init
    @window.makeKeyAndVisible
    true
  end
end

class TestLabelViewController < UIViewController
  def viewDidLoad
    self.view.backgroundColor = UIColor.whiteColor
    self.view.addSubview(normal_label)
    # self.view.addSubview(batch_customization_label)
  end


  def normal_label
    @normal_label ||= EnchantedQuill::Label.alloc.initWithFrame(CGRectMake(20,20,self.view.bounds.size.width-20, 130)).tap do |label|
      label.center                  = self.view.center
      label.text                    = text
      label.textColor               = UIColor.blackColor
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

      label.line_height_multiple    = 1.5
      label.minimum_line_height     = 20
      label.maximum_line_height     = 30

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
  end

  def batch_customization_label
    @batch_customization_label ||= EnchantedQuill::Label.alloc.initWithFrame(CGRectMake(0,280,self.view.bounds.size.width, 130)).tap do |label|
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
    end
  end

  def text
    '@harry_potter plot twist, @voldemort was actually the good guy. ' +
    'He was framed by @dumbledore and @snape #shocker #harrywasliedto ' +
    '{adventure} {spoiler}. Checkout the truth at http://www.harry_is_a.sham or www.harryshouldhaveknown.com'
  end

  def alert(title, string)
    vc = UIAlertController.alertControllerWithTitle(title, message: string, preferredStyle: UIAlertControllerStyleAlert)
    vc.addAction(UIAlertAction.actionWithTitle('Ok', style: UIAlertActionStyleDefault, handler: nil))
    presentViewController(vc, animated: true, completion: nil)
  end
end
