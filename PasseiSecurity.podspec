Pod::Spec.new do |s|
  s.name                  = 'PasseiSecurity'
  s.version               = '0.0.1'
  s.summary               = 'Security'
  s.swift_version         = '6.0'
  s.description           = <<-DESC "Inject certificate PasseiNetworking"
  project
  DESC
  s.homepage              = 'https://github.com/ziminny/PasseiSecurity'
  s.license               = { :type => 'PASSEI-GROUP', :file => 'LICENSE' }
  s.authors               = { 'Vagner Oliveira' => 'ziminny@gmail.com' }
  s.source                = { :git => 'https://github.com/ziminny/PasseiSecurity.git', :tag => s.version.to_s }
  s.ios.deployment_target = '16.0'
  s.osx.deployment_target = '13.0'
  s.source_files          = 'PasseiSecurity/Classes/**/*' 
  s.dependency 'PasseiLogManager'
  end