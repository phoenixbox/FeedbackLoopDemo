//
//  ViewController.m
//  FeedbackLoop
//
//  Created by Shane Rogers on 5/25/15.
//  Copyright (c) 2015 FBL. All rights reserved.
//

#import <FeedbackLoop/FeedbackLoop.h>

#import "ViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import <POP/POP.h>
#import "FBLProspectsStore.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *startChatButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Manul f
    [_mainScrollView setDelegate:self];
//    [self addLabel];
}

- (void)addActivityIndicatorView
{
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicatorView];
    self.navigationItem.rightBarButtonItem = item;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startChat:(UIButton *)button {
    [self hideLabel];
    [self.activityIndicatorView startAnimating];
    button.userInteractionEnabled = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if  (![self validateEmail:_emailInput.text]) {
        [_errorLabel setText:@"Invalid Email. Try again :)"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self.activityIndicatorView stopAnimating];
            [self shakeAndEnableButton];
            [self showLabel];
        });
    } else {
        NSString *email = _emailInput.text;

        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];

        NSDictionary *user = @{
                               @"email": email,
                               @"user_name": email,
                               @"created_at": [DateFormatter stringFromDate:[NSDate date]],
                               @"links": @{
                                       @"referrer": @"ios_demo",
                                       @"model": [UIDevice currentDevice].model,
                                       @"systemName": [UIDevice currentDevice].systemName,
                                       @"systemVersion": [UIDevice currentDevice].systemVersion
                                       }
                               };

        void(^completionBlock)(NSError *error)=^(NSError *error) {
            if (error == nil) {
                [FeedbackLoop registerUnauthenticatedUser:user];
                [FeedbackLoop presentChatChannel];
            } else {
                [_errorLabel setText:@"Cant connect! Try Again :)"];
                [self showLabel];
            };
        };

        [[FBLProspectsStore sharedStore] createProspectForEmail:email withCompletionBlock:completionBlock];
    }
}

- (BOOL)validateEmail:(NSString *)email {
    if([email length]==0){
        return NO;
    }

    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern
                                                                      options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:email options:0 range:NSMakeRange(0, [email length])];

    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark Animations

- (void)shakeAndEnableButton
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        _startChatButton.userInteractionEnabled = YES;
        NSLog(@"LOGIN BUTTON READY AGAIN!");
    }];
    [_startChatButton.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)showLabel
{
    self.errorLabel.layer.opacity = 1.0;
    POPSpringAnimation *layerScaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.springBounciness = 18;
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"labelScaleAnimation"];

    POPSpringAnimation *layerPositionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(_startChatButton.layer.position.y + _startChatButton.intrinsicContentSize.height);
    layerPositionAnimation.springBounciness = 12;
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}

- (void)hideLabel
{
    POPBasicAnimation *layerScaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    layerScaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
    [self.errorLabel.layer pop_addAnimation:layerScaleAnimation forKey:@"layerScaleAnimation"];

    POPBasicAnimation *layerPositionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    layerPositionAnimation.toValue = @(_startChatButton.layer.position.y);
    [self.errorLabel.layer pop_addAnimation:layerPositionAnimation forKey:@"layerPositionAnimation"];
}



@end
