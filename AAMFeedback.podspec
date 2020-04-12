Pod::Spec.new do |s|
  s.name     = 'AAMFeedback'
  s.version  = '0.7.6'
  s.summary  = 'iOS user feedback component for universal use.'
  s.homepage = 'https://github.com/PlusR/AAMFeedback'
  s.authors  = { 'fladdict' => 'fukatsu@gmail.com', 'azu' => 'azuciao@gmail.com' , 'PlusR' => 'sp@plusr.co.jp'}
  s.license  = { :type => 'BSD', :file => 'LICENSE' }
  s.source   = {
    :git => 'https://github.com/PlusR/AAMFeedback.git',
    :tag => s.version.to_s
  }
  s.platform = :ios
  s.ios.deployment_target = '12.0'
  s.source_files = 'src/AAMFeedback/*.{h,m}'
  s.resource_bundles = { 'AAMFeedback' => ['src/Localizations/*.lproj'] }
  s.framework = 'MessageUI'
  s.dependency 'UIDeviceIdentifier'
  s.requires_arc = true
end
