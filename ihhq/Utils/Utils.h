//
//  Utils.h
//  Safar
//
//  Created by k on 11/18/15.
//  Copyright © 2015 kic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define USER_ID @"user_id"
#define FULLNAME @"fullname"
#define PHOTO_URL @"photo_url"

#define ACCESS_TOKEN @"access_token"

#define MESSAGE_TEXT_SIZE_WITH_FONT(message, font) \
[message sizeWithFont:font constrainedToSize:CGSizeMake(WIDTH, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping]

#define UIKeyboardNotificationsObserve() \
NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter]; \
[notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil]; \
[notificationCenter addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil]

#define UIKeyboardNotificationsUnobserve() \
[[NSNotificationCenter defaultCenter] removeObserver:self];

@interface Utils : NSObject

//Validate Email
+(BOOL)validateEmail:(NSString *)emailStr;

//Validate PhoneNumber
+(BOOL)validatePhoneNumber:(NSString*)value;

//Validate String
+(BOOL)checkIfStringContainsText:(NSString *)string;

//Get Time Pass From Date
+(NSString*)getTimeDifferenceFromDate:(NSDate*)date;

//Get Height Of Text by its content, font, width
+(CGFloat)getHeightOfString:(NSString*)content width:(CGFloat)width andFont:(UIFont*)font;
+(CGFloat)getHeightOfAttributedString:(NSAttributedString*)content width:(CGFloat)width andFont:(UIFont*)font;
//Get Width Of Text by its content,font
+ (CGFloat)widthOfString:(NSString *)string withFont:(NSFont *)font;

+(void)drawFrameToViewByAdd:(UIView*)view corner:(CGFloat)cornerRadius border:(CGFloat)border color:(UIColor *)color;

+(void)drawFrameToView:(UIView*)view corner:(CGFloat)cornerRadius border:(CGFloat)border color:(UIColor*)color;

//Draw Circle To the View;
+(void)drawCircleToView:(UIView*)view border:(CGFloat)border color:(UIColor*)color;

//Make View Circle
+(void)makeCircleFromRetacgleView:(UIView*)view radius:(CGFloat)radius;

//Fix Image Orientation
+ (UIImage *)fixrotation:(UIImage *)image;

//Change Placeholder of UITextField
+ (void)changePlacehodlerOfTextField:(UITextField*)textField color:(UIColor*)color placeholderText:(NSString*)placehodlerText;

@end
