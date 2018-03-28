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
#import "NewsObject.h"
#import "MessageObject.h"
#import "SearchPharmacyObject.h"
#import "AllProductObject.h"
#import "AllOfferObject.h"
#import "PharmacyObject.h"
#import "FarmacistObject.h"
#import "OfferTypeObject.h"
#import "NotificationObject.h"
#import "ProfileObject.h"

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
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json", nil];
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
            else if(self.requestType == HTTPRequestTypeNews)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllNewsItems:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestTypeMessage)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllMessageItems:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestTypeAllProducts || self.requestType == HTTPRequestTypeCategoryProducts)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllProducts:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestTypeOffer)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllOfferItems:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestTypeAllOffer || self.requestType == HTTPRequestTypeCategoryOfferProducts)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllOfferTypeItems:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestTypePharmacyDetails)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parsePharmacyDetailsItems:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestTypeFarmacist)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseFarmacistItems:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestTypeNotification)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseNotificationItems:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestypeProfileDetails)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseProfileDetails:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestTypeNotificationDetailsOffer)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseOfferNotification:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestTypeNotificationDetailsNews)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseNewsNotification:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestTypeNotificationDetailsEvent)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseEventNotification:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestTypeNotificationDetailsMessage)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseMessageNotification:responseObject]];
                }
            }
            else {
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
            else if(self.requestType == HTTPRequestTypePharmacySearch || self.requestType == HTTPRequestTypePharmacySearchForCurrentLocation)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllPharmacyItems:responseObject]];
                }
            }
            else if(self.requestType == HTTPRequestTypeProductSearch)
            {
                if([self.delegate respondsToSelector:@selector(dataFromWebReceivedSuccessfully:)])
                {
                    
                    [self.delegate dataFromWebReceivedSuccessfully:[self parseAllProducts:responseObject]];
                }
            }
            else {
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

-(NSMutableArray *) parseAllNewsItems :(id) response
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
                object.name = [[tempArray objectAtIndex:i] valueForKey:@"news_title"];
            }
            else
            {
                object.name = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"news_description"] isKindOfClass:[NSString class]])
            {
                object.details = [[tempArray objectAtIndex:i] valueForKey:@"news_description"];
            }
            else
            {
                object.details = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"news_image_location"] isKindOfClass:[NSString class]])
            {
                object.imageUel = [NSString stringWithFormat:@"%@%@",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"news_image_location"]];
            }
            else
            {
                object.imageUel = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"news_created_edited_date_time"] isKindOfClass:[NSString class]])
            {
                object.creationDate = [[tempArray objectAtIndex:i] valueForKey:@"news_created_edited_date_time"];
            }
            else
            {
                object.creationDate = @"";
            }
            
            [newsItemsArray addObject:object];
        }
        
    }
    return newsItemsArray;
    
}

-(NSMutableArray *) parseAllOfferItems :(id) response
{
    NSMutableArray *offerItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"offer_pdf"] isKindOfClass:[NSArray class]])
    {
        NSArray *tempArray = [(NSArray *)response valueForKey:@"offer_pdf"];
        
        for(NSInteger i = 0; i < tempArray.count; i++)
        {
            AllOfferObject *object = [AllOfferObject new];
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"offer_pdf_id"] isKindOfClass:[NSString class]])
            {
                object.offerId = [[tempArray objectAtIndex:i] valueForKey:@"offer_pdf_id"];
            }
            else
            {
                object.offerId = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"offer_pdf_title"] isKindOfClass:[NSString class]])
            {
                object.offerTitle = [[tempArray objectAtIndex:i] valueForKey:@"offer_pdf_title"];
            }
            else
            {
                object.offerTitle = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"offer_pdf_storage"] isKindOfClass:[NSString class]])
            {
                object.offerPdfLink = [NSString stringWithFormat:@"%@%@",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"offer_pdf_storage"]];
            }
            else
            {
                object.offerPdfLink = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"offer_pdf_starting_date_time"] isKindOfClass:[NSString class]])
            {
                object.startTime = [[tempArray objectAtIndex:i] valueForKey:@"offer_pdf_starting_date_time"];
            }
            else
            {
                object.startTime = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"offer_pdf_ending_date_time"] isKindOfClass:[NSString class]])
            {
                object.endTime = [[tempArray objectAtIndex:i] valueForKey:@"offer_pdf_ending_date_time"];
            }
            else
            {
                object.endTime = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"offer_pdf_from_farma"] isKindOfClass:[NSString class]] && [[[tempArray objectAtIndex:i] valueForKey:@"offer_pdf_from_farma"] isEqualToString:@"1"])
            {
                object.offerType = @"farma logo";
            }
            else
            {
                object.offerType = @"farmacia logo";
            }
            
            [offerItemsArray addObject:object];
        }
        
    }
    return offerItemsArray;
    
}

-(NSMutableArray *) parseAllOfferTypeItems :(id ) response
{
    NSMutableArray *offerItemsArray = [NSMutableArray new];
    NSMutableArray *tempArray = [NSMutableArray new];
    
    if ([[response valueForKey:@"all_offer_products"] isKindOfClass:[NSArray class]]) {
        tempArray = [(NSArray *)response valueForKey:@"all_offer_products"];
    }
    else if ([[response valueForKey:@"offer_pdf_products"] isKindOfClass:[NSArray class]]) {
        tempArray = [(NSArray *)response valueForKey:@"offer_pdf_products"];
    }
    
    for(NSInteger i = 0; i < tempArray.count; i++)
    {
        OfferTypeObject *object = [OfferTypeObject new];
        
        if([[[tempArray objectAtIndex:i] valueForKey:@"product_id"] isKindOfClass:[NSString class]])
        {
            if([[[tempArray objectAtIndex:i] valueForKey:@"descrizione_h1"] isKindOfClass:[NSString class]])
            {
                object.name = [[tempArray objectAtIndex:i] valueForKey:@"descrizione_h1"];
            }
            else
            {
                object.name = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"descrizione_ricerca"] isKindOfClass:[NSString class]])
            {
                object.details = [[tempArray objectAtIndex:i] valueForKey:@"descrizione_ricerca"];
            }
            else
            {
                object.details = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"prezzo_web_lordo"] isKindOfClass:[NSString class]])
            {
                object.price = [[tempArray objectAtIndex:i] valueForKey:@"prezzo_web_lordo"];
            }
            else
            {
                object.price = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"linkImmagineProdotto"] isKindOfClass:[NSString class]])
            {
                object.imageUel = [[tempArray objectAtIndex:i] valueForKey:@"linkImmagineProdotto"];
            }
            else
            {
                object.imageUel = @"";
            }
            
            if((([[[tempArray objectAtIndex:i] valueForKey:@"product_from_json"] isKindOfClass:[NSString class]]) && [[[tempArray objectAtIndex:i] valueForKey:@"product_from_json"]  isEqual: @"1"]) || ([[[tempArray objectAtIndex:i] valueForKey:@"product_new_ref_pharmacy_id"] isKindOfClass:[NSNull class]]) || ([[[tempArray objectAtIndex:i] valueForKey:@"ref_product_free_text_pharmacy_id"] isKindOfClass:[NSNull class]]))
            {
                object.pharmacyCategoryType = @"farma logo";
            }
            else
            {
                object.pharmacyCategoryType = @"farmacia logo";
            }
        }
        else if ([[[tempArray objectAtIndex:i] valueForKey:@"product_new_id"] isKindOfClass:[NSString class]]) {
            if([[[tempArray objectAtIndex:i] valueForKey:@"product_new_descrizione_h1"] isKindOfClass:[NSString class]])
            {
                object.name = [[tempArray objectAtIndex:i] valueForKey:@"product_new_descrizione_h1"];
            }
            else
            {
                object.name = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"product_new_descrizione_ricerca"] isKindOfClass:[NSString class]])
            {
                object.details = [[tempArray objectAtIndex:i] valueForKey:@"product_new_descrizione_ricerca"];
            }
            else
            {
                object.details = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"product_new_prezzo_web_netto"] isKindOfClass:[NSString class]])
            {
                object.price = [[tempArray objectAtIndex:i] valueForKey:@"product_new_prezzo_web_netto"];
            }
            else
            {
                object.price = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"product_new_linkImmagineProdotto"] isKindOfClass:[NSString class]])
            {
                object.imageUel = [[tempArray objectAtIndex:i] valueForKey:@"product_new_linkImmagineProdotto"];
            }
            else
            {
                object.imageUel = @"";
            }
            
            if((([[[tempArray objectAtIndex:i] valueForKey:@"product_from_json"] isKindOfClass:[NSString class]]) && [[[tempArray objectAtIndex:i] valueForKey:@"product_from_json"]  isEqual: @"1"]) || ([[[tempArray objectAtIndex:i] valueForKey:@"product_new_ref_pharmacy_id"] isKindOfClass:[NSNull class]]) || ([[[tempArray objectAtIndex:i] valueForKey:@"ref_product_free_text_pharmacy_id"] isKindOfClass:[NSNull class]]))
            {
                object.pharmacyCategoryType = @"farma logo";
            }
            else
            {
                object.pharmacyCategoryType = @"farmacia logo";
            }
        }
        else if ([[[tempArray objectAtIndex:i] valueForKey:@"product_free_text_id"] isKindOfClass:[NSString class]]) {
            if([[[tempArray objectAtIndex:i] valueForKey:@"product_free_text_name"] isKindOfClass:[NSString class]])
            {
                object.name = [[tempArray objectAtIndex:i] valueForKey:@"product_free_text_name"];
            }
            else
            {
                object.name = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"product_free_text_description"] isKindOfClass:[NSString class]])
            {
                object.details = [[tempArray objectAtIndex:i] valueForKey:@"product_free_text_description"];
            }
            else
            {
                object.details = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"product_free_text_price"] isKindOfClass:[NSString class]])
            {
                object.price = [[tempArray objectAtIndex:i] valueForKey:@"product_free_text_price"];
            }
            else
            {
                object.price = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"product_free_text_image_storage_path"] isKindOfClass:[NSString class]])
            {
                object.imageUel = [NSString stringWithFormat:@"%@%@",BASE_URL_API, [[tempArray objectAtIndex:i] valueForKey:@"product_free_text_image_storage_path"]];
            }
            else
            {
                object.imageUel = @"";
            }
            
            if((([[[tempArray objectAtIndex:i] valueForKey:@"product_from_json"] isKindOfClass:[NSString class]]) && [[[tempArray objectAtIndex:i] valueForKey:@"product_from_json"]  isEqual: @"1"]) || ([[[tempArray objectAtIndex:i] valueForKey:@"product_new_ref_pharmacy_id"] isKindOfClass:[NSNull class]]) || ([[[tempArray objectAtIndex:i] valueForKey:@"ref_product_free_text_pharmacy_id"] isKindOfClass:[NSNull class]]))
            {
                object.pharmacyCategoryType = @"farma logo";
            }
            else
            {
                object.pharmacyCategoryType = @"farmacia logo";
            }
        }
        [offerItemsArray addObject:object];
    }
    return offerItemsArray;
    
}


-(NSMutableArray *) parseAllProducts :(id) response
{
    NSMutableArray *productItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"product"] isKindOfClass:[NSArray class]])
    {
        NSArray *tempArray = [(NSArray *)response valueForKey:@"product"];
        
        for(NSInteger i = 0; i < tempArray.count; i++)
        {
            AllProductObject *object = [AllProductObject new];
            if([[[tempArray objectAtIndex:i] valueForKey:@"final_product_id"] isKindOfClass:[NSString class]])
            {
                object.finalProductId = [NSString stringWithFormat:@"%@",[[tempArray objectAtIndex:i] valueForKey:@"final_product_id"]];
            }
            else
            {
                object.finalProductId = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"product_id"] isKindOfClass:[NSString class]])
            {
                if([[[tempArray objectAtIndex:i] valueForKey:@"descrizione_h1"] isKindOfClass:[NSString class]])
                {
                    object.name = [[tempArray objectAtIndex:i] valueForKey:@"descrizione_h1"];
                }
                else
                {
                    object.name = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"descrizione_ricerca"] isKindOfClass:[NSString class]])
                {
                    object.details = [[tempArray objectAtIndex:i] valueForKey:@"descrizione_ricerca"];
                }
                else
                {
                    object.details = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"prezzo_web_lordo"] isKindOfClass:[NSString class]])
                {
                    object.price = [[tempArray objectAtIndex:i] valueForKey:@"prezzo_web_lordo"];
                }
                else
                {
                    object.price = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"linkImmagineProdotto"] isKindOfClass:[NSString class]])
                {
                    object.imageUel = [[tempArray objectAtIndex:i] valueForKey:@"linkImmagineProdotto"];
                }
                else
                {
                    object.imageUel = @"";
                }
                
                if((([[[tempArray objectAtIndex:i] valueForKey:@"product_from_json"] isKindOfClass:[NSString class]]) && [[[tempArray objectAtIndex:i] valueForKey:@"product_from_json"]  isEqual: @"1"]) || ([[[tempArray objectAtIndex:i] valueForKey:@"product_new_ref_pharmacy_id"] isKindOfClass:[NSNull class]]) || ([[[tempArray objectAtIndex:i] valueForKey:@"ref_product_free_text_pharmacy_id"] isKindOfClass:[NSNull class]]))
                {
                    object.pharmacyCategoryType = @"farma logo";
                }
                else
                {
                    object.pharmacyCategoryType = @"farmacia logo";
                }
            }
            else if ([[[tempArray objectAtIndex:i] valueForKey:@"product_new_id"] isKindOfClass:[NSString class]]) {
                if([[[tempArray objectAtIndex:i] valueForKey:@"product_new_descrizione_h1"] isKindOfClass:[NSString class]])
                {
                    object.name = [[tempArray objectAtIndex:i] valueForKey:@"product_new_descrizione_h1"];
                }
                else
                {
                    object.name = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"product_new_descrizione_ricerca"] isKindOfClass:[NSString class]])
                {
                    object.details = [[tempArray objectAtIndex:i] valueForKey:@"product_new_descrizione_ricerca"];
                }
                else
                {
                    object.details = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"product_new_prezzo_web_netto"] isKindOfClass:[NSString class]])
                {
                    object.price = [[tempArray objectAtIndex:i] valueForKey:@"product_new_prezzo_web_netto"];
                }
                else
                {
                    object.price = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"product_new_linkImmagineProdotto"] isKindOfClass:[NSString class]])
                {
                    object.imageUel = [[tempArray objectAtIndex:i] valueForKey:@"product_new_linkImmagineProdotto"];
                }
                else
                {
                    object.imageUel = @"";
                }
                
                if((([[[tempArray objectAtIndex:i] valueForKey:@"product_from_json"] isKindOfClass:[NSString class]]) && [[[tempArray objectAtIndex:i] valueForKey:@"product_from_json"]  isEqual: @"1"]) || ([[[tempArray objectAtIndex:i] valueForKey:@"product_new_ref_pharmacy_id"] isKindOfClass:[NSNull class]]) || ([[[tempArray objectAtIndex:i] valueForKey:@"ref_product_free_text_pharmacy_id"] isKindOfClass:[NSNull class]]))
                {
                    object.pharmacyCategoryType = @"farma logo";
                }
                else
                {
                    object.pharmacyCategoryType = @"farmacia logo";
                }
            }
            else if ([[[tempArray objectAtIndex:i] valueForKey:@"product_free_text_id"] isKindOfClass:[NSString class]]) {
                if([[[tempArray objectAtIndex:i] valueForKey:@"product_free_text_name"] isKindOfClass:[NSString class]])
                {
                    object.name = [[tempArray objectAtIndex:i] valueForKey:@"product_free_text_name"];
                }
                else
                {
                    object.name = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"product_free_text_description"] isKindOfClass:[NSString class]])
                {
                    object.details = [[tempArray objectAtIndex:i] valueForKey:@"product_free_text_description"];
                }
                else
                {
                    object.details = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"product_free_text_price"] isKindOfClass:[NSString class]])
                {
                    object.price = [[tempArray objectAtIndex:i] valueForKey:@"product_free_text_price"];
                }
                else
                {
                    object.price = @"";
                }
                
                if([[[tempArray objectAtIndex:i] valueForKey:@"product_free_text_image_storage_path"] isKindOfClass:[NSString class]])
                {
                    object.imageUel = [NSString stringWithFormat:@"%@%@",BASE_URL_API, [[tempArray objectAtIndex:i] valueForKey:@"product_free_text_image_storage_path"]];
                }
                else
                {
                    object.imageUel = @"";
                }
                
                if((([[[tempArray objectAtIndex:i] valueForKey:@"product_from_json"] isKindOfClass:[NSString class]]) && [[[tempArray objectAtIndex:i] valueForKey:@"product_from_json"]  isEqual: @"1"]) || ([[[tempArray objectAtIndex:i] valueForKey:@"product_new_ref_pharmacy_id"] isKindOfClass:[NSNull class]]) || ([[[tempArray objectAtIndex:i] valueForKey:@"ref_product_free_text_pharmacy_id"] isKindOfClass:[NSNull class]]))
                {
                    object.pharmacyCategoryType = @"farma logo";
                }
                else
                {
                    object.pharmacyCategoryType = @"farmacia logo";
                }
            }
            
            [productItemsArray addObject:object];
        }
        
    }
    return productItemsArray;
    
}

-(NSMutableArray *) parseAllMessageItems :(id) response
{
    NSMutableArray *messageItemsArray = [NSMutableArray new];
    
    if([[response valueForKey:@"message"] isKindOfClass:[NSArray class]])
    {
        NSArray *tempArray = [(NSArray *)response valueForKey:@"message"];
        
        for(NSInteger i = 0; i < tempArray.count; i++)
        {
            MessageObject *object = [MessageObject new];
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"message_title"] isKindOfClass:[NSString class]])
            {
                object.name = [[tempArray objectAtIndex:i] valueForKey:@"message_title"];
            }
            else
            {
                object.name = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"message_details"] isKindOfClass:[NSString class]])
            {
                object.details = [[tempArray objectAtIndex:i] valueForKey:@"message_details"];
            }
            else
            {
                object.details = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"message_created_date_time"] isKindOfClass:[NSString class]])
            {
                object.creationDate = [[tempArray objectAtIndex:i] valueForKey:@"message_created_date_time"];
            }
            else
            {
                object.creationDate = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"ref_message_pharmacy_id"] isKindOfClass:[NSString class]])
            {
                object.referencePharmacyId = [[tempArray objectAtIndex:i] valueForKey:@"ref_message_pharmacy_id"];
            }
            else
            {
                object.referencePharmacyId = @"";
            }
            
            [messageItemsArray addObject:object];
        }
        
    }
    return messageItemsArray;
    
}

-(NSMutableArray *) parseFarmacistItems :(id) response
{
    NSMutableArray *farmacistArray = [NSMutableArray new];
    
    if([[response valueForKey:@"pharmacists"] isKindOfClass:[NSArray class]])
    {
        NSArray *tempArray = [(NSArray *)response valueForKey:@"pharmacists"];
        
        for(NSInteger i = 0; i < tempArray.count; i++)
        {
            FarmacistObject *object = [FarmacistObject new];
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"farmacisti_first_name"] isKindOfClass:[NSString class]])
            {
                object.firstName = [[tempArray objectAtIndex:i] valueForKey:@"farmacisti_first_name"];
            }
            else
            {
                object.firstName = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"farmacisti_last_name"] isKindOfClass:[NSString class]])
            {
                object.lastName = [[tempArray objectAtIndex:i] valueForKey:@"farmacisti_last_name"];
            }
            else
            {
                object.lastName = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"farmacisti_job_position"] isKindOfClass:[NSString class]])
            {
                object.jobPosition = [[tempArray objectAtIndex:i] valueForKey:@"farmacisti_job_position"];
            }
            else
            {
                object.jobPosition = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"farmacisti_photo_location"] isKindOfClass:[NSString class]])
            {
                object.imagePath = [NSString stringWithFormat:@"%@%@",BASE_URL_API,[[tempArray objectAtIndex:i] valueForKey:@"farmacisti_photo_location"]];
            }
            else
            {
                object.imagePath = @"";
            }
            
            [farmacistArray addObject:object];
        }
        
    }
    return farmacistArray;
    
}

-(NSMutableArray *) parseNotificationItems :(id) response
{
    NSMutableArray *notificationArray = [NSMutableArray new];
    
    if([[response valueForKey:@"notification"] isKindOfClass:[NSArray class]])
    {
        NSArray *tempArray = [(NSArray *)response valueForKey:@"notification"];
        
        for(NSInteger i = 0; i < tempArray.count; i++)
        {
            NotificationObject *object = [NotificationObject new];
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"notification_id"] isKindOfClass:[NSString class]])
            {
                object.notificationId = [[tempArray objectAtIndex:i] valueForKey:@"notification_id"];
            }
            else
            {
                object.notificationId = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"notification_subject_id"] isKindOfClass:[NSString class]])
            {
                object.notificationTypeId = [[tempArray objectAtIndex:i] valueForKey:@"notification_subject_id"];
            }
            else
            {
                object.notificationTypeId = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"notification_title"] isKindOfClass:[NSString class]])
            {
                object.notificationTitle = [[tempArray objectAtIndex:i] valueForKey:@"notification_title"];
            }
            else
            {
                object.notificationTitle = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"ref_notification_pharmacy_id"] isKindOfClass:[NSNull class]])
            {
                object.NotificationCategory = @"farma logo";
            }
            else
            {
                object.NotificationCategory = @"farmacia logo";
            }
            
            [notificationArray addObject:object];
        }
        
    }
    return notificationArray;
    
}

-(ProfileObject *) parseProfileDetails :(id) response
{
    ProfileObject *object = [ProfileObject new];
    object.userName = @"";
    object.firstname = @"";
    object.lastName = @"";
    object.address = @"";
    object.email = @"";
    object.phone = @"";
    object.birthDate = @"";
    
    if([[response valueForKey:@"profile_details"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *tempDic = [(NSDictionary *)response valueForKey:@"profile_details"];
        
        if([[tempDic valueForKey:@"app_user_ecommerce_user_name_email"] isKindOfClass:[NSString class]])
        {
            object.userName = [tempDic valueForKey:@"app_user_ecommerce_user_name_email"];
        }
        else
        {
            object.userName = @"";
        }
        
        if([[tempDic valueForKey:@"app_user_first_name"] isKindOfClass:[NSString class]])
        {
            object.firstname = [tempDic valueForKey:@"app_user_first_name"];
        }
        else
        {
            object.firstname = @"";
        }
        
        if([[tempDic valueForKey:@"app_user_last_name"] isKindOfClass:[NSString class]])
        {
            object.lastName = [tempDic valueForKey:@"app_user_last_name"];
        }
        else
        {
            object.lastName = @"";
        }
        
        if([[tempDic valueForKey:@"app_user_birth_date"] isKindOfClass:[NSString class]])
        {
            object.birthDate = [tempDic valueForKey:@"app_user_birth_date"];
        }
        else
        {
            object.birthDate = @"";
        }
        
        if([[tempDic valueForKey:@"app_user_sex"] isKindOfClass:[NSString class]])
        {
            object.sex = [tempDic valueForKey:@"app_user_sex"];
        }
        else
        {
            object.sex = @"";
        }
        
        if([[tempDic valueForKey:@"app_user_address"] isKindOfClass:[NSString class]])
        {
            object.address = [tempDic valueForKey:@"app_user_address"];
        }
        else
        {
            object.address = @"";
        }
        
        if([[tempDic valueForKey:@"app_user_email"] isKindOfClass:[NSString class]])
        {
            object.email = [tempDic valueForKey:@"app_user_email"];
        }
        else
        {
            object.email = @"";
        }
        
        if([[tempDic valueForKey:@"app_user_cell_phone"] isKindOfClass:[NSString class]])
        {
            object.phone = [tempDic valueForKey:@"app_user_cell_phone"];
        }
        else
        {
            object.phone = @"";
        }
        
    }
    return object;
    
}

-(PharmacyObject *) parsePharmacyDetailsItems :(id) response
{
    PharmacyObject *Pharmacyobject = [PharmacyObject new];
    
    if([[response valueForKey:@"pharmacy_details"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dic = [(NSDictionary *)response valueForKey:@"pharmacy_details"];
        if ([[dic valueForKey:@"telefono"] isKindOfClass:[NSString class]]) {
            Pharmacyobject.phone = [dic valueForKey:@"telefono"];
        }
        else {
            Pharmacyobject.phone = @"";
        }
        
        if ([[dic valueForKey:@"latitudine"] isKindOfClass:[NSString class]]) {
            Pharmacyobject.latitude = [dic valueForKey:@"latitudine"];
        }
        else {
            Pharmacyobject.latitude = @"";
        }
        
        if ([[dic valueForKey:@"longitudine"] isKindOfClass:[NSString class]]) {
            Pharmacyobject.longlititude = [dic valueForKey:@"longitudine"];
        }
        else {
            Pharmacyobject.longlititude = @"";
        }
        
        if ([[dic valueForKey:@"email"] isKindOfClass:[NSString class]]) {
            Pharmacyobject.emailAddress = [dic valueForKey:@"email"];
        }
        else {
            Pharmacyobject.emailAddress = @"";
        }
        
        if ([[dic valueForKey:@"url"] isKindOfClass:[NSString class]]) {
            Pharmacyobject.webAddress = [dic valueForKey:@"url"];
        }
        else {
            Pharmacyobject.webAddress = @"";
        }
        
        if ([[dic valueForKey:@"indirizzo"] isKindOfClass:[NSString class]]) {
            Pharmacyobject.location = [dic valueForKey:@"indirizzo"];
        }
        else {
            Pharmacyobject.location = @"";
        }
        
    }
    
    if([[response valueForKey:@"total_offers"] isKindOfClass:[NSNumber class]])
    {
        Pharmacyobject.totalOffer = [NSString stringWithFormat:@"%@",[response valueForKey:@"total_offers"]];
    }
    else {
        Pharmacyobject.totalOffer = @"0";
    }
    
    if([[response valueForKey:@"event"] isKindOfClass:[NSArray class]])
    {
        Pharmacyobject.eventArray = [NSMutableArray new];
        
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
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"ref_events_pharmacy_id"] isKindOfClass:[NSString class]])
            {
                object.referencePharmacyId = [[tempArray objectAtIndex:i] valueForKey:@"ref_events_pharmacy_id"];
            }
            else
            {
                object.referencePharmacyId = @"";
            }
            
            [Pharmacyobject.eventArray addObject:object];
        }
        
        
    }
    else {
        Pharmacyobject.eventArray = [NSMutableArray new];
    }
    return Pharmacyobject;
    
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
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"ref_events_pharmacy_id"] isKindOfClass:[NSString class]])
            {
                object.referencePharmacyId = [[tempArray objectAtIndex:i] valueForKey:@"ref_events_pharmacy_id"];
            }
            else
            {
                object.referencePharmacyId = @"";
            }
            
            [EventItemsArray addObject:object];
        }
        
    }
    return EventItemsArray;
    
}

-(NSMutableArray *) parseAllPharmacyItems :(id) response
{
    NSMutableArray *pharmacyItemsArray = [NSMutableArray new];
    NSMutableArray *tempArray = [NSMutableArray new];
    
    if([[response valueForKey:@"pharmacy"] isKindOfClass:[NSArray class]] || [[response valueForKey:@"pharmacy_list"] isKindOfClass:[NSArray class]])
    {
        if (self.requestType == HTTPRequestTypePharmacySearch) {
            tempArray = [(NSArray *)response valueForKey:@"pharmacy"];
        }
        else {
            tempArray = [(NSArray *)response valueForKey:@"pharmacy_list"];
        }
        
        for(NSInteger i = 0; i < tempArray.count; i++)
        {
            SearchPharmacyObject *object = [SearchPharmacyObject new];
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"pharmacy_id"] isKindOfClass:[NSString class]])
            {
                object.pharmacyId = [[tempArray objectAtIndex:i] valueForKey:@"pharmacy_id"];
            }
            else
            {
                object.pharmacyId = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"ragione_sociale"] isKindOfClass:[NSString class]])
            {
                object.name = [[tempArray objectAtIndex:i] valueForKey:@"ragione_sociale"];
            }
            else
            {
                object.name = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"indirizzo"] isKindOfClass:[NSString class]])
            {
                object.addres = [[tempArray objectAtIndex:i] valueForKey:@"indirizzo"];
            }
            else
            {
                object.addres = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"cap"] isKindOfClass:[NSString class]])
            {
                object.postalCode = [[tempArray objectAtIndex:i] valueForKey:@"cap"];
            }
            else
            {
                object.postalCode = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"piva"] isKindOfClass:[NSString class]])
            {
                object.vatNumber = [[tempArray objectAtIndex:i] valueForKey:@"piva"];
            }
            else
            {
                object.vatNumber = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"citta"] isKindOfClass:[NSString class]])
            {
                object.city = [[tempArray objectAtIndex:i] valueForKey:@"citta"];
            }
            else
            {
                object.city = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"provincia"] isKindOfClass:[NSString class]])
            {
                object.state = [[tempArray objectAtIndex:i] valueForKey:@"provincia"];
            }
            else
            {
                object.state = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"latitudine"] isKindOfClass:[NSString class]])
            {
                object.latitude = [[tempArray objectAtIndex:i] valueForKey:@"latitudine"];
            }
            else
            {
                object.latitude = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"longitudine"] isKindOfClass:[NSString class]])
            {
                object.longlitude = [[tempArray objectAtIndex:i] valueForKey:@"longitudine"];
            }
            else
            {
                object.longlitude = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"telefono"] isKindOfClass:[NSString class]])
            {
                object.phone = [[tempArray objectAtIndex:i] valueForKey:@"telefono"];
            }
            else
            {
                object.phone = @"";
            }
            
            if([[[tempArray objectAtIndex:i] valueForKey:@"email"] isKindOfClass:[NSString class]])
            {
                object.email = [[tempArray objectAtIndex:i] valueForKey:@"email"];
            }
            else
            {
                object.email = @"";
            }
            
            [pharmacyItemsArray addObject:object];
        }
        
    }
    return pharmacyItemsArray;
    
}

-(AllOfferObject *) parseOfferNotification :(id) response
{
    AllOfferObject *object = [AllOfferObject new];
    if([[response valueForKey:@"notification_details"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *tempDic = [(NSDictionary *)response valueForKey:@"notification_details"];
        
        if([[tempDic valueForKey:@"offer_pdf_id"] isKindOfClass:[NSString class]])
        {
            object.offerId = [tempDic  valueForKey:@"offer_pdf_id"];
        }
        else
        {
            object.offerId = @"";
        }
        
        if([[tempDic valueForKey:@"offer_pdf_title"] isKindOfClass:[NSString class]])
        {
            object.offerTitle = [tempDic valueForKey:@"offer_pdf_title"];
        }
        else
        {
            object.offerTitle = @"";
        }
        
        if([[tempDic valueForKey:@"offer_pdf_storage"] isKindOfClass:[NSString class]])
        {
            object.offerPdfLink = [NSString stringWithFormat:@"%@%@",BASE_URL_API,[tempDic valueForKey:@"offer_pdf_storage"]];
        }
        else
        {
            object.offerPdfLink = @"";
        }
        
        if([[tempDic valueForKey:@"offer_pdf_starting_date_time"] isKindOfClass:[NSString class]])
        {
            object.startTime = [tempDic valueForKey:@"offer_pdf_starting_date_time"];
        }
        else
        {
            object.startTime = @"";
        }
        
        if([[tempDic valueForKey:@"offer_pdf_ending_date_time"] isKindOfClass:[NSString class]])
        {
            object.endTime = [tempDic valueForKey:@"offer_pdf_ending_date_time"];
        }
        else
        {
            object.endTime = @"";
        }
        
        if([[tempDic valueForKey:@"offer_pdf_from_farma"] isKindOfClass:[NSString class]] && [[tempDic valueForKey:@"offer_pdf_from_farma"] isEqualToString:@"1"])
        {
            object.offerType = @"farma logo";
        }
        else
        {
            object.offerType = @"farmacia logo";
        }
        
    }
    return object;
}

-(MessageObject *) parseMessageNotification :(id) response
{
    MessageObject *object = [MessageObject new];
    if([[response valueForKey:@"notification_details"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *tempDic = [(NSDictionary *)response valueForKey:@"notification_details"];
        
        if([[tempDic valueForKey:@"message_title"] isKindOfClass:[NSString class]])
        {
            object.name = [tempDic valueForKey:@"message_title"];
        }
        else
        {
            object.name = @"";
        }
        
        if([[tempDic valueForKey:@"message_details"] isKindOfClass:[NSString class]])
        {
            object.details = [tempDic valueForKey:@"message_details"];
        }
        else
        {
            object.details = @"";
        }
        
        if([[tempDic valueForKey:@"message_created_date_time"] isKindOfClass:[NSString class]])
        {
            object.creationDate = [tempDic valueForKey:@"message_created_date_time"];
        }
        else
        {
            object.creationDate = @"";
        }
        
        if([[tempDic valueForKey:@"ref_message_pharmacy_id"] isKindOfClass:[NSString class]])
        {
            object.referencePharmacyId = [tempDic valueForKey:@"ref_message_pharmacy_id"];
        }
        else
        {
            object.referencePharmacyId = @"";
        }
        
    }
    return object;
}

-(NewsObject *) parseNewsNotification :(id) response
{
    NewsObject *object = [NewsObject new];
    if([[response valueForKey:@"notification_details"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *tempDic = [(NSDictionary *)response valueForKey:@"notification_details"];
        
        if([[tempDic valueForKey:@"news_title"] isKindOfClass:[NSString class]])
        {
            object.name = [tempDic valueForKey:@"news_title"];
        }
        else
        {
            object.name = @"";
        }
        
        if([[tempDic valueForKey:@"news_description"] isKindOfClass:[NSString class]])
        {
            object.details = [tempDic valueForKey:@"news_description"];
        }
        else
        {
            object.details = @"";
        }
        
        if([[tempDic valueForKey:@"news_image_location"] isKindOfClass:[NSString class]])
        {
            object.imageUel = [NSString stringWithFormat:@"%@%@",BASE_URL_API,[tempDic valueForKey:@"news_image_location"]];
        }
        else
        {
            object.imageUel = @"";
        }
        
        if([[tempDic valueForKey:@"news_created_edited_date_time"] isKindOfClass:[NSString class]])
        {
            object.creationDate = [tempDic valueForKey:@"news_created_edited_date_time"];
        }
        else
        {
            object.creationDate = @"";
        }
        
    }
    return object;
}

-(EventObject *) parseEventNotification :(id) response
{
    EventObject *object = [EventObject new];
    if([[response valueForKey:@"notification_details"] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *tempDic = [(NSDictionary *)response valueForKey:@"notification_details"];
        
        if([[tempDic valueForKey:@"events_name"] isKindOfClass:[NSString class]])
        {
            object.name = [tempDic valueForKey:@"events_name"];
        }
        else
        {
            object.name = @"";
        }
        
        if([[tempDic valueForKey:@"events_description"] isKindOfClass:[NSString class]])
        {
            object.details = [tempDic valueForKey:@"events_description"];
        }
        else
        {
            object.details = @"";
        }
        
        if([[tempDic valueForKey:@"events_place"] isKindOfClass:[NSString class]])
        {
            object.location = [tempDic valueForKey:@"events_place"];
        }
        else
        {
            object.location = @"";
        }
        
        if([[tempDic valueForKey:@"events_image_location"] isKindOfClass:[NSString class]])
        {
            object.imageUel = [NSString stringWithFormat:@"%@%@",BASE_URL_API,[tempDic valueForKey:@"events_image_location"]];
        }
        else
        {
            object.imageUel = @"";
        }
        
        if([[tempDic valueForKey:@"events_start_date"] isKindOfClass:[NSString class]])
        {
            object.locationDate = [tempDic valueForKey:@"events_start_date"];
        }
        else
        {
            object.locationDate = @"";
        }
        
        if([[tempDic valueForKey:@"events_start_time"] isKindOfClass:[NSString class]])
        {
            object.startTime = [tempDic valueForKey:@"events_start_time"];
        }
        else
        {
            object.startTime = @"";
        }
        
        if([[tempDic valueForKey:@"events_end_time"] isKindOfClass:[NSString class]])
        {
            object.endTime = [tempDic valueForKey:@"events_end_time"];
        }
        else
        {
            object.endTime = @"";
        }
        
        if([[tempDic valueForKey:@"ref_events_pharmacy_id"] isKindOfClass:[NSString class]])
        {
            object.referencePharmacyId = [tempDic valueForKey:@"ref_events_pharmacy_id"];
        }
        else
        {
            object.referencePharmacyId = @"";
        }
        
    }
    return object;
}


@end
