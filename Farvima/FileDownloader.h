//
//  FileDownloader.h
//  MCP
//
//  Created by Rafay Hasan on 11/16/15.
//  Copyright © 2015 Nascenia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol fileDownloaderDelegate <NSObject>

@optional
- (void)downloadProgres:(NSNumber*)percent forObject:(id)object totalFileSize:(id)fileSize;

@required

- (void)downloadingStarted;
- (void)downloadingFinishedFor:(NSURL *)url andData:(NSData *)data;
- (void)downloadingFailed:(NSURL *)url;

@end


@interface FileDownloader : NSObject
{
@private
    NSMutableURLRequest *_request;
    NSMutableData *downloadedData;
    NSURL *fileUrl;
    
    id <fileDownloaderDelegate> delegate;
    
    double totalFileSize,totalDownloadedData;
}

@property (nonatomic, strong) NSMutableURLRequest *_request;
@property (nonatomic, strong) NSMutableData *downloadedData;
@property (nonatomic, strong) NSURL *fileUrl;
@property (strong,nonatomic) NSURLConnection *cn;

@property (nonatomic, strong) id <fileDownloaderDelegate> delegate;

- (void)downloadFromURL:(NSString *)urlString;

- (void) cancelDownload;

@end
