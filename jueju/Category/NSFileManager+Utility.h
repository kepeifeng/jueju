//
//  NSFileManager+Utility.h
//  officialDemo2D
//
//  Created by Kent Peifeng Ke on 12/22/14.
//  Copyright (c) 2014 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Utility)

-(NSString *)documentFolderPath;
-(NSString *)cacheFolderPath;
/**
 *  @brief  Application Support Folder Path
 *
 *  @return path
 */
-(NSString *)supportFolderPath;
@end
