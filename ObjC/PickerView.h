//
//  PickerView.h
//  <>
//
//  Created by Naveen Shan.
//  Copyright © 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PickerView : NSObject

+ (void)showPickerWithOptions:(NSArray *)options selectionBlock:(void (^)(NSString *selectedOption))block;
+ (void)showPickerWithOptions:(NSArray *)options title:(NSString *)title selectionBlock:(void (^)(NSString *selectedOption))block;

+ (void)showDatePickerWithTitle:(NSString *)title dateMode:(UIDatePickerMode)mode selectionBlock:(void (^)(NSDate *selectedDate))block;

@end
