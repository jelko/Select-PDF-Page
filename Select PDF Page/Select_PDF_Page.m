//
//  Select_PDF_Page.m
//  Select PDF Page
//
//  Created by Jelko Arnds on 15.04.14.
//  Copyright (c) 2014 Jelko Arnds. All rights reserved.
//

#import "Select_PDF_Page.h"
#import <Quartz/Quartz.h>

@implementation Select_PDF_Page

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo
{
    NSMutableArray * output = [NSMutableArray array];
    NSError *error;
    NSString *globallyUniqueString = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *tempDirectoryPath = [NSTemporaryDirectory() stringByAppendingPathComponent:globallyUniqueString];
    NSURL *tempDirectoryURL = [NSURL fileURLWithPath:tempDirectoryPath isDirectory:YES];
    [[NSFileManager defaultManager] createDirectoryAtURL:tempDirectoryURL withIntermediateDirectories:YES attributes:nil error:&error];
    
	for (NSString *path in input) {
		if (![[path pathExtension] isEqualToString:@"pdf"]) {
			[self logMessageWithLevel:AMLogLevelWarn format:@"Skipping '%@' since it is not a PDF", path];
			continue;
		}
		
		NSURL *url = [NSURL fileURLWithPath:path];
		
		if (!url) {
			[self logMessageWithLevel:AMLogLevelError format:@"The path '%@' is invalid", path];
			continue;
		}
		
		PDFDocument *doc = [[PDFDocument alloc] initWithURL:url];
        PDFPage *page;
        
        int searchPage = [[[self parameters] objectForKey:@"page"] intValue];
        if(!searchPage || searchPage == 0){
            [self logMessageWithLevel:AMLogLevelError format:@"Provide a value larger or smaller than 0."];
            continue;
        }
		
		if ([doc pageCount] > 0) {
            if(searchPage > [doc pageCount]){
                [self logMessageWithLevel:AMLogLevelError format:@"PDF does not have to many pages."];
                continue;
            }
            if(![[[self parameters] objectForKey:@"inverse"] boolValue]){
                page = [doc pageAtIndex: searchPage - 1];
            }else{
                page = [doc pageAtIndex:[doc pageCount] - searchPage];
            }
            
		}else{
            [self logMessageWithLevel:AMLogLevelError format:@"The document has no pages."];
            continue;
        }
        
        NSString* newPath = [tempDirectoryPath stringByAppendingPathComponent:[path lastPathComponent]];
        NSURL* newURL = [NSURL fileURLWithPath:newPath];
        PDFDocument* newPDF = [[PDFDocument alloc] initWithData:page.dataRepresentation];
        if([newPDF writeToURL:newURL]){
            [output addObject: newPath];
        }else{
            [self logMessageWithLevel:AMLogLevelError format:@"Error while saving file."];
        }
    }
    
    return output;

}

@end
