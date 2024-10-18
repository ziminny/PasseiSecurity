Pod::Spec.new do |s|
  s.name                  = 'PasseiHTTPCertificate'
  s.version               = '0.0.1'
  s.summary               = 'Terminal Executable'
  s.swift_version         = '6.0'
  s.description           = <<-DESC "Inject certificate PasseiNetworking"
  project
  DESC
  s.homepage              = 'https://github.com/ziminny/PasseiHTTPCertificate'
  s.license               = { :type => 'PASSEI-GROUP', :file => 'LICENSE' }
  s.authors               = { 'Vagner Oliveira' => 'ziminny@gmail.com' }
  s.source                = { :git => 'https://github.com/ziminny/PasseiHTTPCertificate.git', :tag => s.version.to_s }
  s.ios.deployment_target = '16.0'
  s.osx.deployment_target = '13.0'
  s.source_files          = 'PasseiHTTPCertificate/Classes/**/*' 
  s.dependency 'PasseiLogManager'
  end