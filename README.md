# PickerView

Easy to integrate PickerView class using UIAlertController with support of UIPickerView and UIDatePickerView in Swift and objC.

![alt PickerView.png](https://github.com/naveenshan01/PickerView/blob/master/PickerView.png)

To integrate,

NSArray *options = @[@"January",@"February",@"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
 
[PickerView showPickerWithOptions:options title:@"Select a Month" selectionBlock:^(NSString *selectedOption) {
NSLog(@"Select Option : %@",selectedOption);
}];

For more details : https://naveenios.wordpress.com/2015/11/26/pickerview-using-uialertcontroller/
