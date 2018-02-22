//
//  FileDownloader.m
//  MCP
//
//  Created by Rafay Hasan on 11/16/15.
//  Copyright © 2015 Nascenia. All rights reserved.
//

#import "FileDownloader.h"

@implementation FileDownloader

@synthesize _request, downloadedData, fileUrl,cn;
@synthesize delegate;


- (void)downloadFromURL:(NSString *)urlString
{
    totalFileSize = 0.0;
    
    [self setFileUrl:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    self._request = [NSMutableURLRequest requestWithURL:self.fileUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    self.cn = [NSURLConnection connectionWithRequest:self._request delegate:self];
    
    
    [self.cn start];
}


#pragma mark - NSURLConnection Delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    totalFileSize = [response expectedContentLength];
    
    downloadedData = [NSMutableData dataWithCapacity:0];

    NSLog(@"total file size is %.2lf",totalFileSize);
    
    
    if([delegate respondsToSelector:@selector(downloadingStarted)])
    {
        [delegate performSelector:@selector(downloadingStarted)];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [downloadedData appendData:data];
    
    
    //NSNumber *downloadedDataa = [NSNumber numberWithDouble:[downloadedData length] / 1024*1024];
    
//    if([delegate respondsToSelector:@selector(downloadProgres:forObject:)])
//    {
//        [delegate performSelector:@selector(downloadProgres:forObject:) withObject:[NSNumber numberWithFloat:([downloadedData length]/totalFileSize)] withObject:self ];
//    }
    
    if([delegate respondsToSelector:@selector(downloadProgres:forObject:totalFileSize:)])
    {
//        [delegate performSelector:@selector(downloadProgres:forObject:totalFileSize:) withObject:[NSNumber numberWithFloat:([downloadedData length]/totalFileSize)] withObject:[NSNumber numberWithDouble:totalFileSize]];
        
        [delegate performSelector:@selector(downloadProgres:forObject:totalFileSize:) withObject:[NSNumber numberWithDouble:[downloadedData length]] withObject:[NSNumber numberWithDouble:totalFileSize]];
        
        
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if([delegate respondsToSelector:@selector(downloadingFailed:)])
    {
        [delegate performSelector:@selector(downloadingFailed:) withObject:self.fileUrl];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if([delegate respondsToSelector:@selector(downloadingFinishedFor:andData:)])
    {
        [delegate performSelector:@selector(downloadingFinishedFor:andData:) withObject:self.fileUrl withObject:self.downloadedData];
    }
}

- (void) cancelDownload
{
    [self.cn cancel];
    self.cn = nil;
}

@end
