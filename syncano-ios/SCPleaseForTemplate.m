//
//  SCPleaseForTemplate.m
//  syncano-ios
//
//  Created by Jan Lipmann on 10/05/16.
//  Copyright © 2016 Syncano. All rights reserved.
//

#import "SCPleaseForTemplate.h"
#import "SCAPIClient+SCDataObject.h"
#import "SCPleaseProtected.h"

@interface SCPleaseForTemplate()
@property (nonatomic,retain) NSString *templateName;
@end

@implementation SCPleaseForTemplate
- (instancetype)initWithDataObjectClass:(Class)dataObjectClass forTemplate:(NSString *)templateName {
    self = [super init];
    if (self) {
        self.templateName = templateName;
    }
    return self;
}

+ (SCPleaseForTemplate *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forTemplate:(NSString *)templateName {
    SCPleaseForTemplate* instance = (SCPleaseForTemplate*)[self pleaseInstanceForDataObjectWithClass:dataObjectClass];
    instance.templateName = templateName;
    return instance;
}

+ (SCPleaseForTemplate *)pleaseInstanceForDataObjectWithClass:(Class)dataObjectClass forTemplate:(NSString *)templateName forSyncano:(Syncano *)syncano {
    SCPleaseForTemplate* instance = (SCPleaseForTemplate*)[self pleaseInstanceForDataObjectWithClass:dataObjectClass forSyncano:syncano];
    instance.templateName = templateName;
    return instance;
}

- (void)giveMeDataWithParameters:(NSDictionary*)parameters completion:(SCTemplateResponseCompletionBlock)completion {
    SCAPIClient *apiClient = [[self apiClient] copy];
    apiClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *path = [NSString stringWithFormat:@"classes/%@/objects/",self.classNameForAPICalls];
    
    if (parameters != nil) {
        NSMutableDictionary *mutableParams = [parameters mutableCopy];
        mutableParams[@"template_response"] = self.templateName;
        parameters = [NSDictionary dictionaryWithDictionary:mutableParams];
    } else {
        parameters = @{@"template_response" : self.templateName};
    }
    
    [apiClient GETWithPath:path params:parameters completion:^(NSURLSessionDataTask *task, id responseObject, NSError *error) {
        if(completion){
            completion((NSData *)responseObject,error);
        }
    }];
}

@end
