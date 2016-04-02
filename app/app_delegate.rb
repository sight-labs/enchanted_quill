class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launch_options)
    return true if RUBYMOTION_ENV == 'test'
    true
  end
end
