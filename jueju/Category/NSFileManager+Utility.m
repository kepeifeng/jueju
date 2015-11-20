//
//  NSFileManager+Utility.m
//  officialDemo2D
//
//  Created by Kent Peifeng Ke on 12/22/14.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

#import "NSFileManager+Utility.h"

@implementation NSFileManager (Utility)

-(NSString *)documentFolderPath
{
    static NSString *documentFolderPath;
    if(!documentFolderPath)
    {
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentFolderPath = [searchPaths lastObject];
    }
    
    return documentFolderPath;
}

-(NSString *)cacheFolderPath
{
    static NSString *cachePath;
    if(!cachePath)
    {
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        cachePath = [searchPaths lastObject];
    }
    
    return cachePath;
}

-(NSString *)supportFolderPath
{
    static  NSString *applicationSupportDirectory;
    
    if(!applicationSupportDirectory)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        applicationSupportDirectory = [paths firstObject];
        if([self fileExistsAtPath:applicationSupportDirectory] == NO){
            [self createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return applicationSupportDirectory;
}
@end
