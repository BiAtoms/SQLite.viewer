platform :ios, '8.0'

# Disable sending stats
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

target 'SQLiteViewer' do
  use_frameworks!

  # Pods for SQLiteViewer
  pod 'Http.swift', '~> 2.0'
  pod 'SQLite.swift', '~> 0.11.4'

  target 'SQLiteViewerTests' do
    inherit! :search_paths
    pod 'Alamofire', '~> 4.6'
  end
end
