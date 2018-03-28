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
#define PharmacyDetails_URL_API @"app_associate_pharmacy"
#define Gallery_URL_API @"app_gallery_images/"
#define Offer_URL_API @"app_all_offer_pdf_list/"
#define All_OfferList_URL_API @"app_all_offer_products/"
#define PDF_OfferList_URL_API @"app_offer_pdf_products/"
#define Event_URL_API @"app_all_events_by_limit/"
#define Farmacist_URL_API @"app_pharmacist_list/"
#define News_URL_API @"app_all_news_by_limit/"
#define Message_URL_API @"app_message_list_by_app_user_id_limit/"
#define PharmacySearch_URL_API @"app_pharmacy_search"
#define PharmacySearchForCurrentLocation_URL_API @"app_near_by_pharmacy"
#define ChiSiamo_URL_API @"app_farma_about_us"
#define SideMenuCategories_URL_API @"app_all_categories"
#define AllProducts_URL_API @"app_product_list_by_limit/"
#define CategoryProducts_URL_API @"app_category_product_list_by_limit/"
#define CategoryOfferProducts_URL_API @"app_category_offer_products/"
#define CategoryProductSearch_URL_API @"app_search_product"
#define AssociatePharmacy_URL_API @"app_associate_pharmacy"
#define PharmacyDetails_URL_API @"app_associate_pharmacy"
#define CheckPharmacyAssociation_URL_API @"app_user_checking_pharmacy_association/"
#define LoginAuthentication_URL_API @"app_user_login_authentication/"
#define OrderConfirmation_URL_API @"app_order_confirmation/"
#define Notification_URL_API @"notifications/"
#define ProfileDetails_URL_API @"app_user_details/"
#define ProfileModification_URL_API @"app_user_details_update/"

enum {
    HTTPRequestypeUserDetails,
    HTTPRequestypePharmacyDetails,
    HTTPRequestypeProfileDetails,
    HTTPRequestypeProfileModification,
    HTTPRequestTypeGallery,
    HTTPRequestTypeOffer,
    HTTPRequestTypeEvents,
    HTTPRequestTypeNews,
    HTTPRequestTypeMessage,
    HTTPRequestTypeNotification,
    HTTPRequestTypePharmacySearch,
    HTTPRequestTypePharmacySearchForCurrentLocation,
    HTTPRequestTypeChiSiamo,
    HTTPRequestTypeSlideMenuCategory,
    HTTPRequestTypeAllProducts,
    HTTPRequestTypeCategoryProducts,
    HTTPRequestTypeCategoryOfferProducts,
    HTTPRequestTypeProductSearch,
    HTTPRequestTypeAssociatePharmacy,
    HTTPRequestTypePharmacyDetails,
    HTTPRequestTypeFarmacist,
    HTTPRequestTypeAllOffer,
    HTTPRequestTypeCheckPharmacyAssociation,
    HTTPRequestTypeLoginAuthentication,
    HTTPRequestTypeOrderConfirmation
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
