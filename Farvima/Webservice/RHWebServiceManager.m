//
//  RHWebServiceManager.m
//  MCP
//
//  Created by Rafay Hasan on 9/7/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "RHWebServiceManager.h"
//#import "NewsObject.h"
//#import "EventObject.h"
//#import "CourseObject.h"
//#import "MessageObject.h"
//#import "OfferObject.h"
//#import "ServiceObject.h"
//#import "ServiceDetailsObject.h"
//#import "UserInfoObject.h"
//#import "UserProfile.h"
//#import "TicketObject.h"
//#import "TicketDetailsObject.h"
//#import "User Details.h"

@implementation RHWebServiceManager


-(id) initWebserviceWithRequestType: (HTTPRequestType )reqType Delegate:(id) del
{
    if (self=[super init])
    {
        self.delegate = del;
        self.requestType = reqType;
    }
    
    return self;
}

/*
-(void)getDataFromWebURL:(NSString *)requestURL
{
    
    requestURL = [requestURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json",@"text/plain", nil];
    
    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         
         NSInteger statusCode = operation.response.statusCode;
         
         
         NSLog(@"status code is %li",statusCode);
         
         
         if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
         {
//             if(self.requestType == HTTPRequestTypeOngoingEvents || self.requestType == HTTPRequestTypUpcomingEvents)
//             {
//                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                 {
//                     [self.delegate dataFromWebReceivedSuccessfully:[self parseAllEventsItems:responseObject]];
//                 }
//             }
//             else if(self.requestType == HTTPRequestypeNews)
//             {
//                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                 {
//                     [self.delegate dataFromWebReceivedSuccessfully:[self parseNewsItems:responseObject]];
//                 }
//             }
//             else if(self.requestType == HTTPRequestTypeOngoingCourses || self.requestType == HTTPRequestTypeUpComingCourses)
//             {
//                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                 {
//                     [self.delegate dataFromWebReceivedSuccessfully:[self parseCourseItems:responseObject]];
//                 }
//             }
//             else if(self.requestType == HTTPRequestTypeGeneralMessages || self.requestType == HTTPRequestTypeStudioMessages)
//             {
//                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                 {
//                     [self.delegate dataFromWebReceivedSuccessfully:[self parseMessageItems:responseObject]];
//                 }
//             }
//             else if(self.requestType == HTTPRequestypeOffer)
//             {
//                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                 {
//                     [self.delegate dataFromWebReceivedSuccessfully:[self parseOfferItems:responseObject]];
//                 }
//             }
//             else if(self.requestType == HTTPRequestypeAllWebservice || self.requestType == HTTPRequestypeMyWebservice || self.requestType == HTTPRequestypeUserAllWebservice)
//             {
//                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                 {
//                     [self.delegate dataFromWebReceivedSuccessfully:[self parseServicesItems:responseObject]];
//                 }
//             }
//             else if(self.requestType == HTTPRequestypeServiceDetails)
//             {
//                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                 {
//                     [self.delegate dataFromWebReceivedSuccessfully:[self parseServiceDetailsItems:responseObject]];
//                 }
//             }
//             else if(self.requestType == HTTPRequestypeUsersWebService)
//             {
//                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                 {
//                     [self.delegate dataFromWebReceivedSuccessfully:[self parseUserInfo:responseObject]];
//                 }
//             }
//             else if(self.requestType == HTTPRequestypeUserProfile)
//             {
//                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                 {
//                     [self.delegate dataFromWebReceivedSuccessfully:[self parseUserProfile:responseObject]];
//                 }
//             }
//             else if(self.requestType == HTTPRequestypTickets)
//             {
//                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                 {
//                     [self.delegate dataFromWebReceivedSuccessfully:[self parseTicket:responseObject]];
//                 }
//             }
//             else if(self.requestType == HTTPRequestypTicketDetails)
//             {
//                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
//                 {
//                     [self.delegate dataFromWebReceivedSuccessfully:[self parseTicketDetails:responseObject]];
//                 }
//             }
             //else
             {
                 if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                 {
                     
                     [self.delegate dataFromWebReceivedSuccessfully:responseObject];
                 }
             }

        }
         
     }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         NSLog(@"error is %@",error.description);
         
         
         if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
         {
             //DebugLog(@"Object conforms this protocol.");
             if([self.delegate respondsToSelector:@selector(dataFromWebReceiptionFailed:)])
             {
                 // DebugLog(@"Object responds to this selector.");
                 [self.delegate dataFromWebReceiptionFailed:error];
             }
             else
             {
                 //DebugLog(@"Object Doesn't respond to this selector.");
             }
         }
         else
         {
             //DebugLog(@"Object Doesn't conform this protocol.");
         }
         
     }
     ];
    
    
}
*/
-(void)getPostDataFromWebURLWithUrlString:(NSString *)requestURL dictionaryData:(NSDictionary *)postDataDic
{
    requestURL = [requestURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:requestURL parameters:postDataDic progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
        {
            if(self.requestType == HTTPRequestypeUserDetails)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    
                    [self.delegate dataFromWebReceivedSuccessfully:responseObject];
                }
            }
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
        {
            //DebugLog(@"Object conforms this protocol.");
            if([self.delegate respondsToSelector:@selector(dataFromWebReceiptionFailed:)])
            {
                // DebugLog(@"Object responds to this selector.");
                [self.delegate dataFromWebReceiptionFailed:error];
            }
            else
            {
                //DebugLog(@"Object Doesn't respond to this selector.");
            }
        }
    }];
}

/*

-(NSMutableArray *) parseAllEventsItems :(id) response
{
    NSMutableArray *eventsItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"events"] isKindOfClass:[NSArray class]])
    {
        NSArray *tempArray = [(NSArray *)response valueForKey:@"events"];
        
        for(NSInteger i = 0; i < tempArray.count; i++)
        {
            EventObject *object = [EventObject new];
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_name"] isKindOfClass:[NSString class]])
            {
                object.eventName = [[tempArray objectAtIndex:i] valueForKey:@"events_name"];
            }
            else
            {
                object.eventName = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_description"] isKindOfClass:[NSString class]])
            {
                object.eventDescription = [[tempArray objectAtIndex:i] valueForKey:@"events_description"];
                
            }
            else
            {
                object.eventDescription = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"event_web_link_details"] isKindOfClass:[NSString class]])
            {
                object.eventWebLink = [[tempArray objectAtIndex:i] valueForKey:@"event_web_link_details"];
                
            }
            else
            {
                object.eventWebLink = @"";
            }
            
            NSString *startDate,*customDate;
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_start_date"] isKindOfClass:[NSString class]])
            {
                startDate = [[tempArray objectAtIndex:i] valueForKey:@"events_start_date"];
            }
            else
            {
                startDate = @"";
            }
            
            
            NSString *startTime,*customTime;
            
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_start_time"] isKindOfClass:[NSString class]])
            {
                startTime = [[tempArray objectAtIndex:i] valueForKey:@"events_start_time"];
            }
            else
            {
                startTime = @"";
                
            }
            
            
            
            if(startDate.length > 0)
            {
                NSDateFormatter *formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *dt = [formatter dateFromString:startDate];
                [formatter setDateFormat:@"d MMMM yyyy"];
                customDate = [formatter stringFromDate:dt];
            }
            
            if(startTime.length > 0)
            {
                NSDateFormatter *formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"hh:mm:ss"];
                NSDate *time = [formatter dateFromString:startTime];
                [formatter setDateFormat:@"hh:mm a"];
                customTime = [formatter stringFromDate:time];
            }
            
            
            object.eventStartDate = [NSString stringWithFormat:@"%@ %@",customDate,customTime];
            
            
            
            NSString *endDate,*customEndDate;
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_end_date"] isKindOfClass:[NSString class]])
            {
                endDate = [[tempArray objectAtIndex:i] valueForKey:@"events_end_date"];
            }
            else
            {
                endDate = @"";
            }
            
            
            NSString *endTime,*customEndTime;
            
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_end_time"] isKindOfClass:[NSString class]])
            {
                endTime = [[tempArray objectAtIndex:i] valueForKey:@"events_end_time"];
            }
            else
            {
                endTime = @"";
                
            }
            
            
            
            if(endDate.length > 0)
            {
                NSDateFormatter *formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSDate *dt = [formatter dateFromString:endDate];
                [formatter setDateFormat:@"d MMMM yyyy"];
                customEndDate = [formatter stringFromDate:dt];
            }
            
            if(endTime.length > 0)
            {
                NSDateFormatter *formatter = [NSDateFormatter new];
                [formatter setDateFormat:@"hh:mm:ss"];
                NSDate *time = [formatter dateFromString:endTime];
                [formatter setDateFormat:@"hh:mm a"];
                customEndTime = [formatter stringFromDate:time];
            }
            
            
            object.eventEndDate = [NSString stringWithFormat:@"%@ %@",customEndDate,customEndTime];
            
            
            [eventsItemsArray addObject:object];
        }
 
    }
    return eventsItemsArray;

}

-(NSMutableArray *) parseNewsItems :(id) response
{
    
    NSMutableArray *newsItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"news"] isKindOfClass:[NSArray class]])
    {
        NSArray *tempArray = [(NSArray *)response valueForKey:@"news"];
        
        for(NSInteger i = 0; i < tempArray.count; i++)
        {
            NewsObject *object = [NewsObject new];
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"news_title"] isKindOfClass:[NSString class]])
            {
                object.newsTitle = [[tempArray objectAtIndex:i] valueForKey:@"news_title"];
            }
            else
            {
                object.newsTitle = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"news_description"] isKindOfClass:[NSString class]])
            {
                NSString *str = [[tempArray objectAtIndex:i] valueForKey:@"news_description"];
                
                NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
                
                NSAttributedString *attributedStr = [[NSAttributedString alloc]initWithData:data options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
                
                object.newsDescription = attributedStr;
                
            }
            else
            {
                object.newsDescription = [[NSAttributedString alloc]initWithString:@""];
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"news_edited_date_time"] isKindOfClass:[NSString class]])
            {
                object.newsDateTime = [[tempArray objectAtIndex:i] valueForKey:@"news_edited_date_time"];
                
                
                
                NSDateFormatter *formatter = [NSDateFormatter new];
                
                formatter.dateFormat = @"yyyy-MM-d H:mm:ss";
                
                NSDate *myDate = [formatter dateFromString:object.newsDateTime];
                
                formatter.dateFormat = @"dd-MMM-yyy hh:mm a";
                
                object.newsDateTime = [formatter stringFromDate:myDate];
            }
            else
            {
                object.newsDateTime = @"";
            }
            
            [newsItemsArray addObject:object];
        }

    }
    return newsItemsArray;
}

-(NSMutableArray *) parseCourseItems :(id) response
{
    NSMutableArray *courseItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"login_status"] isEqual:[NSNumber numberWithBool:YES]])
    {
        if([[response valueForKey:@"training_course"] isKindOfClass:[NSArray class]])
        {
            NSArray *tempArray = [(NSArray *)response valueForKey:@"training_course"];
            
            for(NSInteger i = 0; i < tempArray.count; i++)
            {
                CourseObject *object = [CourseObject new];
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_title"] isKindOfClass:[NSString class]])
                {
                    object.courseTitle = [[tempArray objectAtIndex:i] valueForKey:@"training_course_title"];
                }
                else
                {
                    object.courseTitle = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_overview"] isKindOfClass:[NSString class]])
                {
                    object.courseOverView = [[tempArray objectAtIndex:i] valueForKey:@"training_course_overview"];
                    
                }
                else
                {
                    object.courseOverView = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_total_class_no"] isKindOfClass:[NSString class]])
                {
                    object.numberOfLessons = [[tempArray objectAtIndex:i] valueForKey:@"training_course_total_class_no"];
                    
                }
                else
                {
                    object.numberOfLessons = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_type_name"] isKindOfClass:[NSString class]])
                {
                    object.courseType = [[tempArray objectAtIndex:i] valueForKey:@"training_course_type_name"];
                    
                }
                else
                {
                    object.courseType = @"0";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_outline"] isKindOfClass:[NSString class]])
                {
                    object.courseOutline = [[tempArray objectAtIndex:i] valueForKey:@"training_course_outline"];
                    
                }
                else
                {
                    object.courseOutline = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_days_name_in_week"] isKindOfClass:[NSString class]])
                {
                    object.coursedaysInWeek = [[tempArray objectAtIndex:i] valueForKey:@"training_course_days_name_in_week"];
                    
                }
                else
                {
                    object.coursedaysInWeek = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_starting_date_time"] isKindOfClass:[NSString class]])
                {
                    object.coursesStartingDate = [[tempArray objectAtIndex:i] valueForKey:@"training_course_starting_date_time"];
                    
                }
                else
                {
                    object.coursesStartingDate = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_ending_date_time"] isKindOfClass:[NSString class]])
                {
                    object.coursesEndingDate = [[tempArray objectAtIndex:i] valueForKey:@"training_course_ending_date_time"];
                    
                }
                else
                {
                    object.coursesEndingDate = @"";
                }
                
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_days_start_time"] isKindOfClass:[NSString class]])
                {
                    object.classStartTime = [[tempArray objectAtIndex:i] valueForKey:@"training_course_days_start_time"];
                    
                }
                else
                {
                    object.classStartTime = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_days_end_time"] isKindOfClass:[NSString class]])
                {
                    object.classEndTime = [[tempArray objectAtIndex:i] valueForKey:@"training_course_days_end_time"];
                    
                }
                else
                {
                    object.classEndTime = @"";
                }
                
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_per_class_duration"] isKindOfClass:[NSString class]])
                {
                    object.perClassDuration = [[tempArray objectAtIndex:i] valueForKey:@"training_course_per_class_duration"];
                    
                }
                else
                {
                    object.perClassDuration = @"";
                }
                
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_orientation_date_time"] isKindOfClass:[NSString class]])
                {
                    object.orientationDateTime = [[tempArray objectAtIndex:i] valueForKey:@"training_course_orientation_date_time"];
                    
                }
                else
                {
                    object.orientationDateTime = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_orientation_date_time"] isKindOfClass:[NSString class]])
                {
                    object.orientationLocation = [[tempArray objectAtIndex:i] valueForKey:@"training_course_orientation_date_time"];
                    
                }
                else
                {
                    object.orientationLocation = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_last_registration_date_time"] isKindOfClass:[NSString class]])
                {
                    object.lastDateOfRegistration = [[tempArray objectAtIndex:i] valueForKey:@"training_course_last_registration_date_time"];
                    
                }
                else
                {
                    object.lastDateOfRegistration = @"";
                }
                
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"training_course_web_link"] isKindOfClass:[NSString class]])
                {
                    object.webLink = [[tempArray objectAtIndex:i] valueForKey:@"training_course_web_link"];
                    
                }
                else
                {
                    object.webLink = @"";
                }
                
                
                [courseItemsArray addObject:object];
            }

        }
    }
    
    return courseItemsArray;
    
}


-(NSMutableArray *) parseMessageItems :(id) response
{
    NSMutableArray *messageItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"login_status"] isEqual:[NSNumber numberWithBool:YES]])
    {
        if([[response valueForKey:@"messages"] isKindOfClass:[NSArray class]])
        {
            NSArray *tempArray = [(NSArray *)response valueForKey:@"messages"];
            NSDateFormatter *formatter = [NSDateFormatter new];
            NSDate *formattedDate = [NSDate new];
            for(NSInteger i = 0; i < tempArray.count; i++)
            {
                MessageObject *object = [MessageObject new];
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"message_title"] isKindOfClass:[NSString class]])
                {
                    object.messageTitle = [[tempArray objectAtIndex:i] valueForKey:@"message_title"];
                }
                else
                {
                    object.messageTitle = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"message_details"] isKindOfClass:[NSString class]])
                {
                    object.messageDetails = [[tempArray objectAtIndex:i] valueForKey:@"message_details"];
                    
                }
                else
                {
                    object.messageDetails = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"message_created_date_time"] isKindOfClass:[NSString class]])
                {
                    NSString *dateTime = [[tempArray objectAtIndex:i] valueForKey:@"message_created_date_time"];
                    
                    NSLog(@"Date time is %@",dateTime);
                    NSArray *tempArray = [dateTime componentsSeparatedByString:@" "];
                    object.messageDate = [tempArray firstObject];
                    object.messageTime = [tempArray lastObject];
                    
                    formatter.dateFormat = @"yyyy-MM-dd";
                    formattedDate = [formatter dateFromString:object.messageDate];
                    formatter.dateFormat = @"dd-MM-yyyy";
                    object.messageDate = [formatter stringFromDate:formattedDate];
                    
                    formatter.dateFormat = @"hh:mm:ss";
                    formattedDate = [formatter dateFromString:object.messageTime];
                    formatter.dateFormat = @"hh:mm a";
                    object.messageTime = [formatter stringFromDate:formattedDate];
                }
                else
                {
                    object.messageDate = @"";
                    
                    object.messageTime = @"";
                }
                
                
                [messageItemsArray addObject:object];
            }

        }
    }
    
    return messageItemsArray;
    
}


-(NSMutableArray *) parseOfferItems :(id) response
{
    NSMutableArray *messageItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"login_status"] isEqual:[NSNumber numberWithBool:YES]])
    {
        
        if([[response valueForKey:@"offers"] isKindOfClass:[NSArray class]])
        {
            NSArray *tempArray = [(NSArray *)response valueForKey:@"offers"];
            NSDateFormatter *formatter = [NSDateFormatter new];
            NSDate *formattedDate = [NSDate new];
            for(NSInteger i = 0; i < tempArray.count; i++)
            {
                OfferObject *object = [OfferObject new];
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"offer_title"] isKindOfClass:[NSString class]])
                {
                    object.offerTitle = [[tempArray objectAtIndex:i] valueForKey:@"offer_title"];
                }
                else
                {
                    object.offerTitle = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"offer_details"] isKindOfClass:[NSString class]])
                {
                    object.offerDetails = [[tempArray objectAtIndex:i] valueForKey:@"offer_details"];
                    
                }
                else
                {
                    object.offerDetails = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"offer_starting_date"] isKindOfClass:[NSString class]])
                {
                    object.offerStartingDate = [[tempArray objectAtIndex:i] valueForKey:@"offer_starting_date"];
                    formatter.dateFormat = @"yyyy-MM-dd";
                    formattedDate  = [formatter dateFromString:object.offerStartingDate];
                    formatter.dateFormat = @"dd MMM yyyy";
                    object.offerStartingDate = [NSString stringWithFormat:@"Start: %@",[formatter stringFromDate:formattedDate]];
                    
                }
                else
                {
                    object.offerStartingDate = @"";
                }
                
//                if([[[tempArray objectAtIndex:i] valueForKey:@"offer_starting_time"] isKindOfClass:[NSString class]])
//                {
//                    object.offerStartingTime = [[tempArray objectAtIndex:i] valueForKey:@"offer_starting_time"];
//                    formatter.dateFormat = @"yyyy-MM-dd";
//                    formattedDate  = [formatter dateFromString:object.offerStartingDate];
//                    formatter.dateFormat = @"dd MMM yyyy";
//                    object.offerStartingDate = [NSString stringWithFormat:@"Start: %@",[formatter stringFromDate:formattedDate]];
//                }
//                else
//                {
//                    object.offerStartingTime = @"";
//                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"offer_ending_date"] isKindOfClass:[NSString class]])
                {
                    object.offerEndDate = [[tempArray objectAtIndex:i] valueForKey:@"offer_ending_date"];
                    formatter.dateFormat = @"yyyy-MM-dd";
                    formattedDate  = [formatter dateFromString:object.offerEndDate];
                    formatter.dateFormat = @"dd MMM yyyy";
                    
                    if([[[tempArray objectAtIndex:i] valueForKey:@"offer_ending_time"] isKindOfClass:[NSString class]])
                    {
                        object.offerEndDate = [NSString stringWithFormat:@"%@ %@",[formatter stringFromDate:formattedDate],[[tempArray objectAtIndex:i] valueForKey:@"offer_ending_time"]];
                        formatter.dateFormat = @"dd MMM yyyy hh:mm:ss";
                        formattedDate  = [formatter dateFromString:object.offerEndDate];
                        formatter.dateFormat = @"dd MMM yyyy - hh:mm a";
                        
                    }
                    object.offerEndDate = [NSString stringWithFormat:@"End: %@",[formatter stringFromDate:formattedDate]];
                }
                else
                {
                    object.offerEndDate = @"";
                }
                
//                if([[[tempArray objectAtIndex:i] valueForKey:@"offer_ending_time"] isKindOfClass:[NSString class]])
//                {
//                    object.offerEndTime = [[tempArray objectAtIndex:i] valueForKey:@"offer_ending_time"];
//                    
//                }
//                else
//                {
//                    object.offerEndTime = @"";
//                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"offer_image_storage_base_path_ios"] isKindOfClass:[NSString class]])
                {
                    NSString *imagePath = [[tempArray objectAtIndex:i] valueForKey:@"offer_image_storage_base_path_ios"];
                    NSString *imageName;
                    
                    
                    if([[[tempArray objectAtIndex:i] valueForKey:@"offer_image_name_as_saved"] isKindOfClass:[NSString class]])
                    {
                        imageName = [[tempArray objectAtIndex:i] valueForKey:@"offer_image_name_as_saved"];
                        
                        object.offerImageUrlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL_API,imagePath,imageName];
                    }
                    else
                        object.offerImageUrlStr = @"";
                    
                    
                }
                else
                {
                    object.offerImageUrlStr = @"";
                }
                
                
                
                
                [messageItemsArray addObject:object];
            }
 
        }
    }
    
    return messageItemsArray;
    
}

-(NSMutableArray *) parseServicesItems :(id) response
{
    NSLog(@"Response is %@",response);
    
    NSMutableArray *serviceItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"login_status"] isEqual:[NSNumber numberWithBool:YES]])
    {
        NSArray *tempArray;
        
        
        if(self.requestType == HTTPRequestypeAllWebservice)
        {
            if([[response valueForKey:@"studio_services"] isKindOfClass:[NSArray class]])
                tempArray = [(NSArray *)response valueForKey:@"studio_services"];
        }
        else
        {
            if([[response valueForKey:@"user_services"] isKindOfClass:[NSArray class]])
                tempArray = [(NSArray *)response valueForKey:@"user_services"];
        }
        
        for(NSInteger i = 0; i < tempArray.count; i++)
        {
            ServiceObject *object = [ServiceObject new];
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"services_id"] isKindOfClass:[NSString class]])
            {
                object.serviceId = [[tempArray objectAtIndex:i] valueForKey:@"services_id"];
            }
            else
            {
                object.serviceId = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"services_code"] isKindOfClass:[NSString class]])
            {
                object.serviceCode = [[tempArray objectAtIndex:i] valueForKey:@"services_code"];
                
            }
            else
            {
                object.serviceCode = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"services_name"] isKindOfClass:[NSString class]])
            {
               object.serviceName = [[tempArray objectAtIndex:i] valueForKey:@"services_name"];
                
            }
            else
            {
                object.serviceName = @"";
            }
            
            if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
            {
                if([[[tempArray objectAtIndex:i] valueForKey:@"studio_services_unread_update"] isKindOfClass:[NSString class]])
                {
                    NSString *str = [NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] valueForKey:@"studio_services_unread_update"]];
                    object.unreadServicesArray = [str componentsSeparatedByString:@","];
                    object.totalUpdateCount = [NSString stringWithFormat:@"%li",object.unreadServicesArray.count];
                    
                }
                else
                {
                    object.unreadServicesArray = [NSArray new];
                    object.totalUpdateCount = @"0";
                }
            }
            else
            {
                if([[[tempArray objectAtIndex:i] valueForKey:@"user_services_unread_update"] isKindOfClass:[NSString class]])
                {
                    NSString *str = [NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] valueForKey:@"user_services_unread_update"]];
                    object.unreadServicesArray = [str componentsSeparatedByString:@","];
                    object.totalUpdateCount = [NSString stringWithFormat:@"%li",object.unreadServicesArray.count];
                }
                else
                {
                    object.unreadServicesArray = [NSArray new];
                    object.totalUpdateCount = @"0";
                }

            }
            

            if([[[tempArray objectAtIndex:i] valueForKey:@"ref_user_services_user_details_id"] isKindOfClass:[NSString class]])
            {
                object.refUserServiceUserDetailsId = [[tempArray objectAtIndex:i] valueForKey:@"ref_user_services_user_details_id"];
                
            }
            else
            {
                object.refUserServiceUserDetailsId = @"-";
            }
            
            [serviceItemsArray addObject:object];
        }
        
    }
    
    return serviceItemsArray;
    
}

-(NSMutableArray *)parseServiceDetailsItems:(id) response
{
    NSMutableArray *serviceDetailsItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"login_status"] isEqual:[NSNumber numberWithBool:YES]])
    {
        if([[response valueForKey:@"service_update"] isKindOfClass:[NSArray class]])
        {
            NSArray *tempArray = [(NSArray *)response valueForKey:@"service_update"];
            
            for(NSInteger i = 0; i < tempArray.count; i++)
            {
                ServiceDetailsObject *object = [ServiceDetailsObject new];
                if([[[tempArray objectAtIndex:i] valueForKey:@"services_update_id"] isKindOfClass:[NSString class]])
                {
                    object.serviceUpdateId = [[tempArray objectAtIndex:i] valueForKey:@"services_update_id"];
                }
                else
                {
                    object.serviceUpdateId = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"services_update_title"] isKindOfClass:[NSString class]])
                {
                    object.updateTitle = [[tempArray objectAtIndex:i] valueForKey:@"services_update_title"];
                }
                else
                {
                    object.updateTitle = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"services_update_details"] isKindOfClass:[NSString class]])
                {
                    object.updateDetails = [[tempArray objectAtIndex:i] valueForKey:@"services_update_details"];
                    
                }
                else
                {
                    object.updateDetails = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"services_update_link"] isKindOfClass:[NSString class]])
                {
                    object.updateWeblink = [[tempArray objectAtIndex:i] valueForKey:@"services_update_link"];;
                    
                    
                }
                else
                {
                    object.updateWeblink = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"services_update_created_date_time"] isKindOfClass:[NSString class]])
                {
                    object.updateDateTime = [[tempArray objectAtIndex:i] valueForKey:@"services_update_created_date_time"];
                    
                }
                else
                {
                    object.updateDateTime = @"0";
                }
                
                
                [serviceDetailsItemsArray addObject:object];
            }

        }
    }
    
    return serviceDetailsItemsArray;
}


-(NSMutableArray *) parseUserInfo :(id) response
{
    NSLog(@"response %@",response);
    
    NSMutableArray *userInfoArray = [NSMutableArray new];
    
    if([[response valueForKey:@"login_status"] isEqual:[NSNumber numberWithBool:YES]])
    {
        if([[response valueForKey:@"users"] isKindOfClass:[NSArray class]])
        {
            NSArray *tempArray = [(NSArray *)response valueForKey:@"users"];
            
            for(NSInteger i = 0; i < tempArray.count; i++)
            {
                UserInfoObject *object = [UserInfoObject new];
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"user_details_id"] isKindOfClass:[NSString class]])
                {
                    object.userDetailsId = [[tempArray objectAtIndex:i] valueForKey:@"user_details_id"];
                }
                else
                {
                    object.userDetailsId = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"user_details_id"] isKindOfClass:[NSString class]])
                {
                    object.targetUserDetailsId = [[tempArray objectAtIndex:i] valueForKey:@"user_details_id"];
                    
                }
                else
                {
                    object.targetUserDetailsId = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"user_details_first_name"] isKindOfClass:[NSString class]])
                {
                    object.firstName = [[tempArray objectAtIndex:i] valueForKey:@"user_details_first_name"];
                    
                }
                else
                {
                    object.firstName = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"user_details_last_name"] isKindOfClass:[NSString class]])
                {
                    object.lastName = [[tempArray objectAtIndex:i] valueForKey:@"user_details_last_name"];
                    
                }
                else
                {
                    object.lastName = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"user_details_user_name"] isKindOfClass:[NSString class]])
                {
                    object.userName = [[tempArray objectAtIndex:i] valueForKey:@"user_details_user_name"];
                    
                }
                else
                {
                    object.userName = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"user_details_password_hash_value"] isKindOfClass:[NSString class]])
                {
                    object.password = [[tempArray objectAtIndex:i] valueForKey:@"user_details_password_hash_value"];
                    
                }
                else
                {
                    object.password = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"user_details_email_address"] isKindOfClass:[NSString class]])
                {
                    object.Email = [[tempArray objectAtIndex:i] valueForKey:@"user_details_email_address"];
                    
                }
                else
                {
                    object.Email = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"user_details_cell_phone"] isKindOfClass:[NSString class]])
                {
                    object.cellPhone = [[tempArray objectAtIndex:i] valueForKey:@"user_details_cell_phone"];
                    
                }
                else
                {
                    object.cellPhone = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"user_details_city"] isKindOfClass:[NSString class]])
                {
                    object.city = [[tempArray objectAtIndex:i] valueForKey:@"user_details_city"];
                    
                }
                else
                {
                    object.city = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"user_details_country"] isKindOfClass:[NSString class]])
                {
                    object.country = [[tempArray objectAtIndex:i] valueForKey:@"user_details_country"];
                    
                }
                else
                {
                    object.country = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"user_details_created_by_admin"] isKindOfClass:[NSString class]] && [[[tempArray objectAtIndex:i]valueForKey:@"user_details_created_by_admin"] isEqualToString:@"1"])
                {
                    object.userAddedByAdmin = @"1";
                    
                }
                else
                {
                    object.userAddedByAdmin = @"0";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"user_details_active"] isKindOfClass:[NSString class]] && [[[tempArray objectAtIndex:i]valueForKey:@"user_details_active"] isEqualToString:@"1"])
                {
                    object.userActive = @"1";
                    
                }
                else
                {
                    object.userActive = @"0";
                }
                
                
                
                
                [userInfoArray addObject:object];
            }

        }
    }
    
    return userInfoArray;
    
}

-(UserInfoObject *) parseUserProfile:(id) response
{
    
    NSLog(@"response is %@",response);
    
    NSArray *tempArray = (NSArray *)response;
    
    UserInfoObject *object = [UserInfoObject new];
    
    if([[tempArray valueForKey:@"user_details_id"] isKindOfClass:[NSString class]])
    {
        object.userDetailsId = [tempArray valueForKey:@"user_details_id"];
    }
    else
    {
        object.userDetailsId = @"";
    }
    
    object.targetUserDetailsId = object.userDetailsId;
    
    if([[tempArray valueForKey:@"user_details_first_name"] isKindOfClass:[NSString class]])
    {
        object.firstName = [tempArray valueForKey:@"user_details_first_name"];
    }
    else
    {
        object.firstName = @"";
    }
    
    if([[tempArray valueForKey:@"user_details_last_name"] isKindOfClass:[NSString class]])
    {
        object.lastName = [tempArray valueForKey:@"user_details_last_name"];
    }
    else
    {
        object.lastName = @"";
    }
    
    if([[tempArray valueForKey:@"user_details_user_name"] isKindOfClass:[NSString class]])
    {
        object.userName = [tempArray valueForKey:@"user_details_user_name"];
    }
    else
    {
        object.userName = @"";
    }
    
    if([[tempArray valueForKey:@"user_details_password_hash_value"] isKindOfClass:[NSString class]])
    {
        object.password = [tempArray valueForKey:@"user_details_password_hash_value"];
    }
    else
    {
        object.password = @"";
    }
    
    if([[tempArray valueForKey:@"user_details_email_address"] isKindOfClass:[NSString class]])
    {
        object.Email = [tempArray valueForKey:@"user_details_email_address"];
    }
    else
    {
        object.Email = @"";
    }
    
    if([[tempArray valueForKey:@"user_details_cell_phone"] isKindOfClass:[NSString class]])
    {
        object.cellPhone = [tempArray valueForKey:@"user_details_cell_phone"];
    }
    else
    {
        object.cellPhone = @"";
    }
    
    if([[tempArray valueForKey:@"user_details_city"] isKindOfClass:[NSString class]])
    {
        object.city = [tempArray valueForKey:@"user_details_city"];
    }
    else
    {
        object.city = @"";
    }
    
    if([[tempArray valueForKey:@"user_details_country"] isKindOfClass:[NSString class]])
    {
        object.country = [tempArray valueForKey:@"user_details_country"];
    }
    else
    {
        object.country = @"";
    }
    
    
    if([[tempArray valueForKey:@"user_details_created_by_admin"] isKindOfClass:[NSString class]] && [[tempArray valueForKey:@"user_details_created_by_admin"] isEqualToString:@"1"])
    {
        object.userAddedByAdmin = @"1";
        
    }
    else
    {
        object.userAddedByAdmin = @"0";
    }
    
    if([[tempArray valueForKey:@"user_details_active"] isKindOfClass:[NSString class]] && [[tempArray valueForKey:@"user_details_active"] isEqualToString:@"1"])
    {
        object.userActive = @"1";
        
    }
    else
    {
        object.userActive = @"0";
    }
    
    if([[tempArray valueForKey:@"total_user_services"] isKindOfClass:[NSString class]])
    {
        object.totalUserService = [tempArray valueForKey:@"total_user_services"];
    }
    else
    {
        object.totalUserService = @"";
    }

    
    if([[tempArray valueForKey:@"total_studio_services"] isKindOfClass:[NSString class]])
    {
        object.totalStudioService = [tempArray valueForKey:@"total_studio_services"];
    }
    else
    {
        object.totalStudioService = @"";
    }

    
    
    
    return object;
}



-(NSMutableArray *) parseTicket :(id) response
{
    NSMutableArray *messageItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"login_status"] isEqual:[NSNumber numberWithBool:YES]])
    {
        if([[response valueForKey:@"ticket_information"] isKindOfClass:[NSArray class]])
        {
            NSArray *tempArray = [(NSArray *)response valueForKey:@"ticket_information"];
            NSDateFormatter *formatter = [NSDateFormatter new];
            NSDate *formattedDate = [NSDate new];
            
            for(NSInteger i = 0; i < tempArray.count; i++)
            {
                TicketObject *object = [TicketObject new];
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"ticket_id"] isKindOfClass:[NSNumber class]])
                {
                    object.ticketId = [NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] valueForKey:@"ticket_id"]];
                }
                else
                {
                    object.ticketId = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"ticket_description"] isKindOfClass:[NSString class]])
                {
                    object.ticketDescription = [[tempArray objectAtIndex:i] valueForKey:@"ticket_description"];
                    
                }
                else
                {
                    object.ticketDescription = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"ticket_creating_date"] isKindOfClass:[NSString class]])
                {
                    object.ticketCreationDate = [[tempArray objectAtIndex:i] valueForKey:@"ticket_creating_date"];
                    formatter.dateFormat = @"dd-MM-yyyy HH:mm:ss";
                    formattedDate  = [formatter dateFromString:object.ticketCreationDate];
                    formatter.dateFormat = @"dd MMM yyyy hh:mm a";
                    object.ticketCreationDate = [formatter stringFromDate:formattedDate];
                }
                else
                {
                    object.ticketCreationDate = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"status_ticket_id"] isKindOfClass:[NSString class]])
                {
                    object.statusTicketId = [[tempArray objectAtIndex:i] valueForKey:@"status_ticket_id"];
                    
                }
                else
                {
                    object.statusTicketId = @"";
                }
                
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"status_changed_date"] isKindOfClass:[NSString class]])
                {
                    object.statusChangedDate = [[tempArray objectAtIndex:i] valueForKey:@"status_changed_date"];
                    formatter.dateFormat = @"dd-MM-yyyy HH:mm:ss";
                    formattedDate  = [formatter dateFromString:object.statusChangedDate];
                    formatter.dateFormat = @"dd MMM yyyy hh:mm a";
                    object.statusChangedDate = [formatter stringFromDate:formattedDate];
                    
                }
                else
                {
                    object.statusChangedDate = @"";
                }
                
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"current_status"] isKindOfClass:[NSString class]])
                {
                    object.currentStatus= [[tempArray objectAtIndex:i] valueForKey:@"current_status"];
                    
                }
                else
                {
                    object.currentStatus = @"";
                }
                
                
                
                [messageItemsArray addObject:object];
            }

        }
        
        
        
    }
    
    return messageItemsArray;
    
}

-(NSMutableArray *) parseTicketDetails :(id) response
{
    NSMutableArray *messageItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"login_status"] isEqual:[NSNumber numberWithBool:YES]])
    {
        if([[response valueForKey:@"ticket_information"] isKindOfClass:[NSArray class]])
        {
            NSArray *tempArray = [(NSArray *)response valueForKey:@"ticket_information"];
            
            for(NSInteger i = 0; i < tempArray.count; i++)
            {
                TicketDetailsObject *object = [TicketDetailsObject new];
                
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"replying_type"] isKindOfClass:[NSString class]])
                {
                    object.replyType = [[tempArray objectAtIndex:i] valueForKey:@"replying_type"];
                    
                }
                else
                {
                    object.replyType = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"replying_date"] isKindOfClass:[NSString class]])
                {
                    object.replyDate = [[tempArray objectAtIndex:i] valueForKey:@"replying_date"];
                    
                }
                else
                {
                    object.replyDate = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"replying_message"] isKindOfClass:[NSString class]])
                {
                    object.replyMessage = [[tempArray objectAtIndex:i] valueForKey:@"replying_message"];
                    
                }
                else
                {
                    object.replyMessage = @"";
                }
                
                
                
                [messageItemsArray addObject:object];
            }

        }
    }
    
    return messageItemsArray;
    
}
*/



@end
