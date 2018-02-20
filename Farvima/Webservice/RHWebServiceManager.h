//
//  RHWebServiceManager.h
//  MCP
//
//  Created by Rafay Hasan on 9/7/15.
//  Copyright (c) 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define BASE_URL_API @"http://farmadevelopment.switchyapp.com/"
#define UserDetails_URL_API @"ios_store_device_id_tokens"
#define Gallery_URL_API @"app_gallery_images/"
#define Event_URL_API @"app_all_events_by_limit/"
#define News_URL_API @"app_all_news_by_limit/"
#define Message_URL_API @"app_message_list_by_app_user_id_limit/"
#define PharmacySearch_URL_API @"app_pharmacy_search"
#define ChiSiamo_URL_API @"app_farma_about_us"
#define SideMenuCategories_URL_API @"app_all_categories"
#define AllProducts_URL_API @"app_product_list_by_limit/"
#define CategoryProducts_URL_API @"app_category_product_list_by_limit/"
#define CategoryProductSearch_URL_API @"app_search_product"

enum {
    HTTPRequestypeUserDetails,
    HTTPRequestTypeGallery,
    HTTPRequestTypeEvents,
    HTTPRequestTypeNews,
    HTTPRequestTypeMessage,
    HTTPRequestTypePharmacySearch,
    HTTPRequestTypeChiSiamo,
    HTTPRequestTypeSlideMenuCategory,
    HTTPRequestTypeAllProducts,
    HTTPRequestTypeCategoryProducts,
    HTTPRequestTypeProductSearch
};
typedef NSUInteger HTTPRequestType;


@protocol RHWebServiceDelegate <NSObject>

@optional

-(void) dataFromWebReceivedSuccessfully:(id) responseObj;
-(void) dataFromWebReceiptionFailed:(NSError*) error;
-(void) dataFromWebDidnotReceiveSuccessMessage:( id )responseObj;


@end


@interface RHWebServiceManager : NSObject

@property (nonatomic, retain) id <RHWebServiceDelegate> delegate;


@property (readwrite, assign) HTTPRequestType requestType;

-(id) initWebserviceWithRequestType: (HTTPRequestType )reqType Delegate:(id) del;

-(void)getDataFromWebURLWithUrlString:(NSString *)requestURL;

-(void)getPostDataFromWebURLWithUrlString:(NSString *)requestURL dictionaryData:(NSDictionary *)postDataDic;


@end
