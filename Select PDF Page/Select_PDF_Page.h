//
//  Select_PDF_Page.h
//  Select PDF Page
//
//  Created by Jelko Arnds on 15.04.14.
//  Copyright (c) 2014 Jelko Arnds. All rights reserved.
//

#import <Automator/AMBundleAction.h>

@interface Select_PDF_Page : AMBundleAction

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end
