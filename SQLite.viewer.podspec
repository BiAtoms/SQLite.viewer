Pod::Spec.new do |s|
    s.name             = 'SQLite.viewer'
    s.version          = '2.0.0'
    s.summary          = 'An elegant library for debugging sqlite databases in iOS applications'
    s.homepage         = 'https://github.com/BiAtoms/SQLite.viewer'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Orkhan Alikhanov' => 'orkhan.alikhanov@gmail.com' }
    s.source           = { :git => 'https://github.com/BiAtoms/SQLite.viewer.git', :tag => s.version.to_s }
    s.module_name      = 'SQLiteViewer'

    s.ios.deployment_target = '8.0'
    s.source_files = 'Sources/*.swift'
    s.resource_bundles = { 'com.biatoms.sqlite-viewer.assets' => ['Sources/**/*.{js,css,ico,html}'] }

    s.dependency 'Http.swift', '2.0.0'
    s.dependency 'SQLite.swift', '>= 0.11.4'
end
