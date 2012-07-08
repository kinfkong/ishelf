//
//  UtilModel.m
//  obanana
//
//  Created by Wang Jinggang on 11-6-8.
//  Copyright 2011 tencent. All rights reserved.
//

#import "UtilModel.h"
#import "XMLHelper.h"
#import <CoreLocation/CLLocation.h>

#define DATA(X) [X dataUsingEncoding:NSUTF8StringEncoding]

#define IMAGE_CONTENT @"Content-Disposition: form-data; name=\"%@\";\
	filename=\"image.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n"

#define STRING_CONTENT @"Content-Disposition: form-data;\
	name=\"%@\"\r\n\r\n"

#define MULTIPART @"multipart/form-data; boundary=------------0x0x0x0x0x0x0x0x"


@implementation UtilModel

static UtilModel* instance = nil;


+(UtilModel *) getInstance {
	if (instance == nil) {
		instance = [[UtilModel alloc] init];
	}
	return instance;
}

-(NSData *) generateFormDataFromPostDictionary:(NSDictionary *) dict {
	// set the boundary
	NSString* boundary = @"------------0x0x0x0x0x0x0x0x";
	NSArray* keys = [dict allKeys];
	NSMutableData* result = [NSMutableData data];
	for (int i = 0; i < [keys count]; i++) {
		id value = [dict valueForKey:[keys objectAtIndex:i]];
		[result appendData:
		 [[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		if ([value isKindOfClass:[UIImage class]]) {
			NSString* formstring = [NSString stringWithFormat:IMAGE_CONTENT, [keys objectAtIndex:i]];
			[result appendData:DATA(formstring)];
			
			// deal with the image rotation
			UIImage* image = (UIImage *) value;
			
			/*if (image.imageOrientation == UIImageOrientationLeft
				|| image.imageOrientation == UIImageOrientationRight) {
				image = [image imageRotatedByDegrees:90.];
			}*/
			
			NSData* imageData = UIImageJPEGRepresentation(image, 0.8);
			[result appendData:imageData];
		} else if ([value isKindOfClass:[CLLocation class]]) {
			CLLocation* location = (CLLocation *) value;
			NSString* formstring = [NSString stringWithFormat:STRING_CONTENT, [keys objectAtIndex:i]];
			NSString* locationstring = [NSString stringWithFormat:@"(%lf %lf)", 
										location.coordinate.longitude, location.coordinate.latitude];
			
			[result appendData: DATA(formstring)];
			[result appendData:DATA(locationstring)];
		} else {
			NSString* formstring = [NSString stringWithFormat:STRING_CONTENT, [keys objectAtIndex:i]];
			[result appendData: DATA(formstring)];
			[result appendData:DATA(value)];
		}
		
		// put end of the part 
		NSString* formstring = @"\r\n";
		[result appendData:DATA(formstring)];
		
	}
	NSString* formstring = [NSString stringWithFormat:@"--%@--\r\n", boundary];
	[result appendData:DATA(formstring)];
	return result;
}


-(NSURLRequest *) generateRequesWithURL:(NSString*) baseURL PostDictionary:(NSDictionary *) dict {
	NSURL* url = [NSURL URLWithString:baseURL];
	//  cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval
	NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];
	if (!urlRequest) {
		// TODO: error
		return nil;
	}
	
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setValue:MULTIPART forHTTPHeaderField:@"Content-Type"];
	NSData* postData = [self generateFormDataFromPostDictionary:dict];
	NSLog(@"postdata_len:%d", [postData length]);
	//NSLog(@"postdata: %@", [NSString stringWithUTF8String:[postData bytes]]);
	[urlRequest setHTTPBody:postData];
	return urlRequest;
	
}

-(BOOL) postData:(NSDictionary *) data toURL:(NSString *) url {
	NSURLRequest* request = [self generateRequesWithURL:url PostDictionary:data];
	NSURLResponse* response;
	NSError* error;
	NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	if (!result) {
		//NSLog(@"failed to send request..:%@", error);
		return NO;
	}
    /*
	NSLog(@"send ok ...response:%@", [NSString stringWithUTF8String:[result bytes]]);
     */
    XMLHelper* helper = [[XMLHelper alloc] init];
	NSDictionary* dict = [helper parseXML2Dictionary:result];
	[helper release];
    if (dict == nil) {
        return NO;
    }
    if (![[dict objectForKey:@"errno"] isEqualToString:@"0"]) {
        return NO;
    }
	return YES;
}


-(NSString *) getReadableDateDiffBetweenDate1:(NSString *) date1 andDate2:(NSString *) date2 {
	NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSDate* d1 = [formatter dateFromString:date1];
	NSDate* d2 = [formatter dateFromString:date2];
	
	NSCalendar* calendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
	NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
	NSDateComponents *cps = [ calendar components:unitFlags fromDate:d1  toDate:d2  options:0];
	NSInteger diffHour = [ cps hour ];
	NSInteger diffMin    = [ cps minute ];
	NSInteger diffSec   = [ cps second ];
	NSInteger diffDay   = [ cps day ];
	NSInteger diffMon  = [ cps month ];
	NSInteger diffYear = [ cps year ];
	
	[formatter release];
	[calendar release];
	
	//NSLog(@"%d,%d,%d,%d,%d,%d", diffYear, diffMon, diffDay, diffHour, diffMin, diffSec);
	if (diffYear > 0) {
		return [NSString stringWithFormat:@"%d年", diffYear];
	} else if (diffMon > 0) {
		return [NSString stringWithFormat:@"%d月", diffMon];
	} else if (diffDay > 0) {
		return [NSString stringWithFormat:@"%d天", diffDay];
	} else if (diffHour > 0) {
		return [NSString stringWithFormat:@"%d小时", diffHour];		
	} else if (diffMin > 0) {
		return [NSString stringWithFormat:@"%d分钟", diffMin];		
	} else if (diffSec > 0) {
		return [NSString stringWithFormat:@"%d秒前", diffSec];			
	} else {
		return [NSString stringWithFormat:@"%@", @"刚刚"];
	}
	
}

-(NSString *) getReplyMsg:(NSDictionary *) data {
	if ([[data objectForKey:@"del"] isEqualToString:@"1"]) {
		return @"原文已被作者删除";
	}
	NSString* msg = [data objectForKey:@"msg"];
	if (msg == nil) {
		msg = @"";
	}
	return [NSString stringWithFormat:@"%@: %@", [data objectForKey:@"user_nick"], msg];
}

@end
