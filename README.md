# LXMExpandLayout    
A UICollectionViewLayout that can expand one item with spring animation without doing any transition,  support cell with any size.

LXMExpandLayout is a imitation of [DaiExpandCollectionView](https://github.com/DaidoujiChen/DaiExpandCollectionView) by @[DaidoujiChen](https://github.com/DaidoujiChen) and I made several improvements to make it more easy to use.    

Now it supports cell with any size, you can use it just like any other UICollectionViewFlowLayout, all you have to do is to set the itemSize and then all are done .

It also works well with autoLayout, since you need only to set the item size, you may see different UI on different devices, for example:      
with itemSize set to {80, 100}, you will see three items in one row on iPhone5, but you will see four on iPhone6.   
![image](https://raw.githubusercontent.com/Phelthas/LXMExpandLayout/master/ScreenShots/ScreenShotForiPhone5.gif "iphone5")         ![image](https://raw.githubusercontent.com/Phelthas/LXMExpandLayout/master/ScreenShots/ScreenShotForiPhone6.gif "iphone6")   



##Install 
###Using cocoaPods
1, add `pod 'LXMExpandLayout', '~> 0.0.1'`to your podFile    
2, run `pod install` or `pod update`        

###manually
1, add `LXMExpandLayout.h`,`LXMExpandLayout.m`,`UICollectionView+LXMExpandLayout.h`,`UICollectionView+LXMExpandLayout.m` to your project

##How to use
1,add `#import "LXMExpandLayout.h"` to your viewController    
2,init a LXMExpandLayout and set it to the collectionView like this :       

       LXMExpandLayout *expandLayout = [[LXMExpandLayout alloc] init];
       expandLayout.itemSize = CGSizeMake(80, 100);
       self.collectionView.collectionViewLayout = expandLayout;
  ok, all is done.       
  
3,if you want to chane a seletedItem, just call this method      

    [self.collectionView expandItemAtIndexPath:indexPath animated:YES];    
    
    
##Todo
1, take `sectionInset` into account     
2, support addItem , deleteItem and other opration    
3, support multipule sections     


## 帮助
如果有什么问题，欢迎issue和pullRequest  

## License
LXMExpandLayout is available under the MIT license. See the LICENSE file for more info. 





