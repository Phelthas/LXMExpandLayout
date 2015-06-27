# LXMExpandLayout    
A UICollectionViewLayout that can expand one item with spring animation without doing any transition,  support cell with any size.

LXMExpandLayout is a imitation of [DaiExpandCollectionView](https://github.com/DaidoujiChen/DaiExpandCollectionView) by @[DaidoujiChen](https://github.com/DaidoujiChen) and I made several improvements to make it more easy to use.    

It supports cell with any size, you can use it just like any other UICollectionViewFlowLayout, all you have to do is to set the itemSize and then all are done .

Now you can drag a item to reorder it, remember that you must implement the delegate method to insure that th order did changed.

It also works well with autoLayout, since you need only to set the item size, you may see different UI on different devices, for example:      
with itemSize set to {80, 100}, you will see three items in one row on iPhone5, but you will see four on iPhone6.   
![image](https://raw.githubusercontent.com/Phelthas/LXMExpandLayout/master/ScreenShots/ScreenShotForiPhone5.gif "iphone5")         ![image](https://raw.githubusercontent.com/Phelthas/LXMExpandLayout/master/ScreenShots/ScreenShotForiPhone6.gif "iphone6")   


##Attention
there are some limitation on this LXMExpandLayout, the itemSize you set, however, you must make sure that there are at least three items in one row, otherwise it will do not work......

##Update
version 0.0.3, fix some bugs, support drag to reorder       
inpired by [RACollectionViewReorderableTripletLayout](https://github.com/ra1028/RACollectionViewReorderableTripletLayout) by [ra1028](https://github.com/ra1028)


version 0.0.2, support sectionInsect    
now you can set the `sectionInsect`of LXMExpandLayout and it will work just like UICollectionViewFlowLayout



##Install 
###Using cocoaPods
1, add `pod 'LXMExpandLayout', '0.0.2'`to your podFile    
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
1, support addItem , deleteItem and other opration    
2, support multipule sections     


## Help
if you have any questions or suggestions, wellcome for issues and pullRequest.    


## License
LXMExpandLayout is available under the MIT license. See the LICENSE file for more info. 





