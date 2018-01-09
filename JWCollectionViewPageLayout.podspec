Pod::Spec.new do |s|

  s.name         = "JWCollectionViewPageLayout"
  s.version      = "0.0.1"
  s.summary      = "Page layout for UICollectionView"
  s.description  = "Vertical layout in page, horizontal layout for page"

  s.homepage     = "https://github.com/Javen-fly/JWCollectionViewPageLayout"

  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "960838547@qq.com" => "Javenfly" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/Javen-fly/JWCollectionViewPageLayout.git", :tag => "0.0.1" }

  s.source_files  = "JWCollectionViewPageLayoutDemo/JWCollectionViewPageLayout/*.{h,m}"

  s.requires_arc = true
  # s.dependency "JSONKit", "~> 1.4"

end
