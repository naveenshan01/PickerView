//
//  PickerView.m
//  <>
//
//  Created by Naveen Shan.
//  Copyright © 2015. All rights reserved.
//

#import "PickerView.h"

#pragma mark - Picker Controller

@interface PickerAlertController : UIAlertController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSString *pickerTitle;
@property (nonatomic, strong) UIBarButtonItem *titleButton;

@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSString *selectedOption;
@property (nonatomic, copy) void (^pickerDoneBlock)(NSString *selectedOption);

@end

@implementation PickerAlertController

- (instancetype)init    {
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.toolbar = [[UIToolbar alloc] init];
    self.toolbar.clipsToBounds = YES;
    [self.view addSubview:self.toolbar];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancel:)];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone:)];
    UIBarButtonItem *flexibleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.titleButton = [[UIBarButtonItem alloc] initWithTitle:self.pickerTitle style:UIBarButtonItemStylePlain target:nil action:nil];
    self.titleButton.tintColor = [UIColor blackColor];

    [self.toolbar setItems:@[cancelButton,flexibleButton,self.titleButton,flexibleButton,doneButton]];
    
    [self createPickerView];
}

- (void)createPickerView {
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.clipsToBounds = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:self.pickerView];
}

- (void)setOptions:(NSArray *)options {
    _options = options;
    
    if ([options count] > 0) {
        self.selectedOption = self.options.firstObject;
    }
}

- (void)setPickerTitle:(NSString *)pickerTitle {
    _pickerTitle = pickerTitle;
    
    self.titleButton.title = pickerTitle;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat screenWidth = self.view.frame.size.width;
    self.toolbar.frame = CGRectMake(0, 0, screenWidth, 0);
    [self.toolbar sizeToFit];
    self.pickerView.frame = CGRectMake(0, self.toolbar.bounds.size.height, screenWidth, 180);
}

#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.options.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component   {
    return self.options[row];
}

#pragma mark - UIPickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    self.selectedOption = self.options[row];
}

#pragma mark -

- (void)pickerDone:(id)sender {
    if (self.pickerDoneBlock) {
        self.pickerDoneBlock(self.selectedOption);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pickerCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

#pragma mark - DatePicker Controller

@interface DatePickerController : PickerAlertController

@property (nonatomic, strong) UIDatePicker *datePickerView;
@property (nonatomic, copy) void (^datePickerDoneBlock)(NSDate *selectedDate);

@end

@implementation DatePickerController

- (void)createPickerView {
    self.datePickerView = [[UIDatePicker alloc] init];
    self.datePickerView.clipsToBounds = YES;
    [self.view addSubview:self.datePickerView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat screenWidth = self.view.frame.size.width;
    self.datePickerView.frame = CGRectMake(0, self.toolbar.bounds.size.height, screenWidth, 180);
}

#pragma mark -

- (void)pickerDone:(id)sender {
    if (self.datePickerDoneBlock) {
        self.datePickerDoneBlock(self.datePickerView.date);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

#pragma mark - Picker View

@implementation PickerView

+ (UIViewController *)presentationContorller    {
    UIViewController *presentationContorller = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (presentationContorller == nil) {
        presentationContorller = [[[UIApplication sharedApplication] windows] firstObject].rootViewController;
    }
    
    if (![presentationContorller isMemberOfClass:[UIViewController class]]) {
        if ([presentationContorller isKindOfClass:[UITabBarController class]]) {
            presentationContorller = ((UITabBarController *)presentationContorller).selectedViewController;
        } else if ([presentationContorller isKindOfClass:[UINavigationController class]]) {
            presentationContorller = ((UINavigationController *)presentationContorller).topViewController;
        }
        else {
            presentationContorller = presentationContorller.presentedViewController;
        }
    }
    
    return presentationContorller;
}

#pragma mark -

+ (void)showPickerWithOptions:(NSArray *)options selectionBlock:(void (^)(NSString *selectedOption))block  {
    [[self class] showPickerWithOptions:options title:nil selectionBlock:block];
}

+ (void)showPickerWithOptions:(NSArray *)options title:(NSString *)title selectionBlock:(void (^)(NSString *selectedOption))block  {
    PickerAlertController *alertController = [PickerAlertController alertControllerWithTitle:title message:@"\n\n\n\n\n\n\n\n\n\n\n"preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.options = options;
    alertController.pickerTitle = title;
    [alertController setPickerDoneBlock:block];
    
    [[[self class] presentationContorller] presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -

+ (void)showDatePickerWithTitle:(NSString *)title dateMode:(UIDatePickerMode)mode selectionBlock:(void (^)(NSDate *selectedDate))block  {
    DatePickerController *alertController = [DatePickerController alertControllerWithTitle:title message:@"\n\n\n\n\n\n\n\n\n\n\n"preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.pickerTitle = title;
    alertController.datePickerView.datePickerMode = mode;
    [alertController setDatePickerDoneBlock:block];
    
    [[[self class] presentationContorller] presentViewController:alertController animated:YES completion:nil];
}


@end
