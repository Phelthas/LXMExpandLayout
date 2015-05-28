
Pod::Spec.new do |s|


  s.name         = "LXMExpandLayoutw"
  s.version      = "0.0.1"
  s.summary      = "A UICollectionViewLayout that can expand one item with spring animation without doing any transition, support cell with any size."

  s.description  = <<-DESC
	LXMExpandLayout is a imitation of DaiExpandCollectionView and I made several improvements to make it more easy to use.

Now it supports cell with any size, you can use it just like any other UICollectionViewFlowLayout, all you have to do is to set the itemSize and then all are done .
                   DESC

  s.homepage     = "https://github.com/Phelthas/LXMExpandLayout"

  s.license      = "MIT"

  s.author             = { "Phelthas" => "billthas@gmail.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "git@github.com:Phelthas/LXMExpandLayout.git", :tag => "0.0.1" }

  s.source_files  = "LXMExpandLayoutDemo/LXMExpandLayout/*.{h,m}"

  s.frameworks = "Foundation", "UIKit"

  s.requires_arc = true


end
