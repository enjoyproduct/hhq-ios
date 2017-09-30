//
//  Utils.m
//  Safar
//
//  Created by k on 11/18/15.
//  Copyright © 2015 kic. All rights reserved.
//

#import "Utils.h"

@implementation Utils


//---Validate Email
+(BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

//Validate PhoneNumber
+(BOOL)validatePhoneNumber:(NSString*)value
{
    NSCharacterSet* character = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"].invertedSet;
    NSArray* inputString = [value componentsSeparatedByCharactersInSet:character];
    NSString* filteredString = [inputString componentsJoinedByString:@""];
    if ([value isEqualToString:filteredString]) {
        return YES;
    }else{
        return NO;
    }   
}

//Validate String
+(BOOL)checkIfStringContainsText:(NSString *)string
{
    if(!string || string == NULL || [string isEqual:[NSNull null]])
        return FALSE;
    
    NSString *newString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([newString isEqualToString:@""])
        return FALSE;
    
    return TRUE;
}

//Get Time Pass From Date
+(NSString*)getTimeDifferenceFromDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyy HH:mm:ss"];
    
    // Add this part to your code
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setTimeZone:timeZone];
    
    NSTimeInterval timeDifference = [[NSDate date] timeIntervalSinceDate:date];

    
    NSDate* differentDate = [NSDate dateWithTimeIntervalSinceReferenceDate:timeDifference];
    NSString *dateAsString = [formatter stringFromDate:differentDate];
    NSDate* UTCdifferentDate = [formatter dateFromString:dateAsString];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    [calendar setTimeZone:timeZone];
    NSDateComponents* components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute | NSCalendarUnitSecond)  fromDate:UTCdifferentDate];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    if ((year-2001) != 0) {
        return [NSString stringWithFormat:@"%ldY",(long)(year - 2001)];
    }else if ((month - 1) != 0){
        return [NSString stringWithFormat:@"%ldM",(long)(month - 1)];
    }else if (day - 1 != 0){
        return [NSString stringWithFormat:@"%ldD",(long)(day - 1)];
    }else if (hour != 0){
        return [NSString stringWithFormat:@"%ldh", (long)hour];
    }else if (minute != 0){
        return [NSString stringWithFormat:@"%ldm",(long)minute];
    }else{
        return [NSString stringWithFormat:@"%lds",(long)second];
    }

}

+(CGFloat)getHeightOfString:(NSString*)content width:(CGFloat)width andFont:(UIFont*)font
{
    NSDictionary* attributes = @{NSFontAttributeName:font};
    CGFloat height = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size.height;
    
    return height;
    
}
+(CGFloat)getHeightOfAttributedString:(NSAttributedString*)content width:(CGFloat)width andFont:(UIFont*)font
{
    NSDictionary* attributes = @{NSFontAttributeName:font};
    CGFloat height = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.height;
    
    return height;
    
}

+ (CGFloat)widthOfString:(NSString *)string withFont:(NSFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];

    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

+(void)drawFrameToViewByAdd:(UIView*)view corner:(CGFloat)cornerRadius border:(CGFloat)border color:(UIColor *)color
{
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:view.bounds cornerRadius:cornerRadius];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.lineWidth = border;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [view.layer addSublayer:shapeLayer];
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = border;
}

+(void)drawFrameToView:(UIView*)view corner:(CGFloat)cornerRadius border:(CGFloat)border color:(UIColor *)color
{
    
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = border;
}



+(void)drawCircleToView:(UIView*)view border:(CGFloat)border color:(UIColor*)color
{
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:view.bounds];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [color CGColor];
    shapeLayer.lineWidth = border;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [view.layer addSublayer:shapeLayer];
}

/**
 * converts time (in milliseconds) to human-readable format
 *  "<v> weeks, <w> days, <x> hours, <y> minutes and (z) seconds"
 */
#define ONE_SECOND  1
#define ONE_MINUTE  (ONE_SECOND * 60)
#define ONE_HOUR    (ONE_MINUTE * 60)
#define ONE_DAY     (ONE_HOUR * 24)
#define ONE_WEEK    (ONE_DAY * 7)

+ (NSString *)secondToLongWDHMS:(long) duration {
    int temp = 0;
    NSString* unit = @"";
    
    if ((temp = (int)(duration / ONE_SECOND)) < 60) {
        unit = (temp <= 1) ? @"sec" : @"secs";
    } else if ((temp = (int)(duration / ONE_MINUTE)) < 60) {
        unit = (temp == 1) ? @"min" : @"mins";
    } else if ((temp = (int)(duration / ONE_HOUR)) < 24) {
        unit = (temp == 1) ? @"hour" : @"hours";
    } else if ((temp = (int)(duration / ONE_DAY)) < 7) {
        unit = (temp == 1) ? @"day" : @"days";
    } else {
        temp = (int)(duration / ONE_WEEK);
        unit = (temp == 1) ? @"week" : @"weeks";
    }
    
    
    return [NSString stringWithFormat:@"%d %@ ago", temp, unit];
}

+ (NSString *) changeDistanceUnit:(NSNumber*)distance
{
    if ([distance intValue] > 999) {
        return [NSString stringWithFormat:@"%dkm",(int)([distance intValue] / 1000)];
    }else{
        return [NSString stringWithFormat:@"%@m", distance];
    }
}

+ (NSString *) changeDistanceWithMile : (NSNumber*) distance
{
    return [NSString stringWithFormat:@"%.3fmile", (float)([distance floatValue] / 1852)];
}



+ (void) setImage:(UIImageView*)view imageName:(NSString*)imageName selected:(BOOL)selected {
    NSString* imageFile = [NSString stringWithFormat:@"%@%@.png", imageName, selected ? @"_selected" : @""];
    [view setImage:[UIImage imageNamed:imageFile]];
}

+ (UIImage*) scaleAndCropImage:(UIImage *) imgSource toSize:(CGSize)newSize
{
    float ratio = imgSource.size.width / imgSource.size.height;
    
    UIGraphicsBeginImageContext(newSize);
    
    if (ratio > 1) {
        CGFloat newWidth = ratio * newSize.width;
        CGFloat newHeight = newSize.height;
        CGFloat leftMargin = (newWidth - newHeight) / 2;
        [imgSource drawInRect:CGRectMake(-leftMargin, 0, newWidth, newHeight)];
    }
    else {
        CGFloat newWidth = newSize.width;
        CGFloat newHeight = newSize.height / ratio;
        CGFloat topMargin = (newHeight - newWidth) / 2;
        [imgSource drawInRect:CGRectMake(0, -topMargin, newSize.width, newSize.height/ratio)];
    }
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



+ (NSDictionary *)countryCodesByName
{
    static NSDictionary *_countryCodesByName = nil;
    if (!_countryCodesByName)
    {
        NSDictionary *countryNamesByCode = [self countryNamesByCode];
        NSMutableDictionary *codesByName = [NSMutableDictionary dictionary];
        for (NSString *code in countryNamesByCode)
        {
            codesByName[countryNamesByCode[code]] = code;
        }
        _countryCodesByName = [codesByName copy];
    }
    return _countryCodesByName;
}

+ (NSDictionary *)countryNamesByCode
{
    static NSDictionary *_countryNamesByCode = nil;
    if (!_countryNamesByCode)
    {
        NSMutableDictionary *namesByCode = [NSMutableDictionary dictionary];
        for (NSString *code in [NSLocale ISOCountryCodes])
        {
            NSString *countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:code];
            
            //workaround for simulator bug
            if (!countryName)
            {
                countryName = [[NSLocale localeWithLocaleIdentifier:@"fr"] displayNameForKey:NSLocaleCountryCode value:code];
            }
            
            namesByCode[code] = countryName ?: code;
        }
        _countryNamesByCode = [namesByCode copy];
    }
    return _countryNamesByCode;
}

+ (void)changePlacehodlerOfTextField:(UITextField*)textField color:(UIColor*)color placeholderText:(NSString*)placehodlerText
{
    if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placehodlerText attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
}

//Make View Circle
+(void)makeCircleFromRetacgleView:(UIView*)view radius:(CGFloat)radius
{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds = YES;
}

+ (UIImage *)fixrotation:(UIImage *)image{
    
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
    
}


@end
