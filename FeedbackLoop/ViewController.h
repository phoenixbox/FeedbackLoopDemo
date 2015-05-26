//
//  ViewController.h
//  FeedbackLoop
//
//  Created by Shane Rogers on 5/25/15.
//  Copyright (c) 2015 FBL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@interface ViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>

- (IBAction)startChat:(UIButton *)button;

@end

