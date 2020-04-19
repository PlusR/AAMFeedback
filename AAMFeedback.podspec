Pod::Spec.new do |s|
  s.name     = 'AAMFeedback'
  s.version  = '1.0.0'
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
  s.resource_bundles = { 'AAMFeedback' => ['src/Localizations/*.lproj'] }
  s.framework = 'MessageUI'
  s.requires_arc = true
  s.default_subspec = 'ObjC'
  s.swift_version = '5.1'

  s.subspec 'ObjC' do |objc|
    objc.source_files = 'src/AAMFeedback/*.{h,m}'
    objc.dependency 'UIDeviceIdentifier'
  end

  s.subspec 'Swift' do |swift|
    swift.source_files = 'src/Feedback/*.{swift}'
  end
end
