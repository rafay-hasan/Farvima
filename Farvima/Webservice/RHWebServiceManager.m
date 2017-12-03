//
//  RHWebServiceManager.m
//  MCP
//
//  Created by Rafay Hasan on 9/7/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import "RHWebServiceManager.h"
#import "GalleryObject.h"
#import "EventObject.h"

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

-(void)getDataFromWebURLWithUrlString:(NSString *)requestURL
{
    requestURL = [requestURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:requestURL parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        if([self.delegate conformsToProtocol:@protocol(RHWebServiceDelegate)])
        {
            if(self.requestType == HTTPRequestTypeGallery)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllGalleryItems:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestTypeEvents)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllEventItems:responseObject]];
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



-(NSMutableArray *) parseAllGalleryItems :(id) response
{
    NSMutableArray *galleryItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"images"] isKindOfClass:[NSArray class]])
    {
        NSArray *tempArray = [(NSArray *)response valueForKey:@"images"];
        
        for(NSInteger i = 0; i < tempArray.count; i++)
        {
            GalleryObject *object = [GalleryObject new];
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"gallery_image_title"] isKindOfClass:[NSString class]])
            {
                object.name = [[tempArray objectAtIndex:i] valueForKey:@"gallery_image_title"];
            }
            else
            {
                object.name = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"gallery_image_description"] isKindOfClass:[NSString class]])
            {
                object.details = [[tempArray objectAtIndex:i] valueForKey:@"gallery_image_description"];
            }
            else
            {
                object.details = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"gallery_image_storage_path"] isKindOfClass:[NSString class]])
            {
                object.imageUel = [NSString stringWithFormat:@"%@%@",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"gallery_image_storage_path"]];
            }
            else
            {
                object.imageUel = @"";
            }
            
            [galleryItemsArray addObject:object];
        }
 
    }
    return galleryItemsArray;

}

-(NSMutableArray *) parseAllEventItems :(id) response
{
    NSMutableArray *EventItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"event"] isKindOfClass:[NSArray class]])
    {
        NSArray *tempArray = [(NSArray *)response valueForKey:@"event"];
        
        for(NSInteger i = 0; i < tempArray.count; i++)
        {
            EventObject *object = [EventObject new];
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_name"] isKindOfClass:[NSString class]])
            {
                object.name = [[tempArray objectAtIndex:i] valueForKey:@"events_name"];
            }
            else
            {
                object.name = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_description"] isKindOfClass:[NSString class]])
            {
                object.details = [[tempArray objectAtIndex:i] valueForKey:@"events_description"];
            }
            else
            {
                object.details = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_place"] isKindOfClass:[NSString class]])
            {
                object.location = [[tempArray objectAtIndex:i] valueForKey:@"events_place"];
            }
            else
            {
                object.location = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_image_location"] isKindOfClass:[NSString class]])
            {
                object.imageUel = [NSString stringWithFormat:@"%@%@",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"events_image_location"]];
            }
            else
            {
                object.imageUel = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_start_date"] isKindOfClass:[NSString class]])
            {
                object.locationDate = [[tempArray objectAtIndex:i] valueForKey:@"events_start_date"];
            }
            else
            {
                object.locationDate = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_start_time"] isKindOfClass:[NSString class]])
            {
                object.startTime = [[tempArray objectAtIndex:i] valueForKey:@"events_start_time"];
            }
            else
            {
                object.startTime = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"events_end_time"] isKindOfClass:[NSString class]])
            {
                object.endTime = [[tempArray objectAtIndex:i] valueForKey:@"events_end_time"];
            }
            else
            {
                object.endTime = @"";
            }
            
            [EventItemsArray addObject:object];
        }
        
    }
    return EventItemsArray;
    
}

@end
