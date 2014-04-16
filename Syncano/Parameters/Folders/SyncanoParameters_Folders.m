//
//  SyncanoParameters_Folders.m
//  Syncano
//
//  Created by Syncano Inc. on 07/01/14.
//  Copyright (c) 2014 Syncano Inc. All rights reserved.
//

#import "SyncanoParameters_Folders.h"
#import "SyncanoResponse_Folders.h"

@implementation SyncanoParameters_Folders_Name

- (SyncanoParameters_Folders_Name *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId name:(NSString *)name {
    self = [super init];
    if (self) {
        self.projectId = projectId;
        self.collectionId = collectionId;
        self.name = name;
        [self validateSpecialParameters:@[@"projectId", @"collectionId", @"name"]];
    }
    return self;
}

- (SyncanoParameters_Folders_Name *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey name:(NSString *)name {
    self = [super init];
    if (self) {
        self.projectId = projectId;
        self.collectionKey = collectionKey;
        self.name = name;
        [self validateSpecialParameters:@[@"projectId", @"collectionKey", @"name"]];
    }
    return self;
}

- (NSArray *)initalizeSelectorNamesArray {
    return @[@"initWithProjectId:collectionId:name:",@"initWithProjectId:collectionKey:name:"];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary * parameters = @{@"projectId" : @"project_id",
                                  @"collectionId" : @"collection_id",
                                  @"collectionKey" : @"collection_key",
                                  @"name" : @"name"};
    return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Folders_New

- (NSString *)methodName {
	return @"folder.new";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Folders_New responseFromJSON:json];
}

@end

@implementation SyncanoParameters_Folders_Get

- (NSString *)methodName {
	return @"folder.get";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Folders_Get responseFromJSON:json];
}

@end

@implementation SyncanoParameters_Folders_GetOne

- (SyncanoParameters_Folders_GetOne *)initWithProjectId:(NSString *)projectId collectionId:(NSString *)collectionId folderName:(NSString *)folderName{
    self = [super init];
    if (self) {
        self.projectId = projectId;
        self.collectionId = collectionId;
        self.folderName = folderName;
        [self validateSpecialParameters:@[@"projectId", @"collectionId"]];
    }
    return self;
}

- (SyncanoParameters_Folders_GetOne *)initWithProjectId:(NSString *)projectId collectionKey:(NSString *)collectionKey folderName:(NSString *)folderName{
    self = [super init];
    if (self) {
        self.projectId = projectId;
        self.collectionKey = collectionKey;
        self.folderName = folderName;
        [self validateSpecialParameters:@[@"projectId", @"collectionKey"]];
    }
    return self;
}

- (NSArray *)initalizeSelectorNamesArray {
    return @[@"initWithProjectId:collectionId:folderName:",@"initWithProjectId:collectionKey:folderName:"];
}

- (NSString *)methodName {
	return @"folder.get_one";
}

- (id)responseFromJSON:(NSDictionary *)json {
	return [SyncanoResponse_Folders_GetOne responseFromJSON:json];
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary * parameters = @{@"projectId" : @"project_id",
                                  @"collectionId" : @"collection_id",
                                  @"collectionKey" : @"collection_key",
                                  @"folderName" : @"folder_name"};
    return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}


@end

@implementation SyncanoParameters_Folders_Update

- (NSString *)methodName {
	return @"folder.update";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary * parameters = @{@"name" : @"new_name",
                                  @"sourceId" : @"source_id"};
    return [SyncanoParameters mergeSuperParameters:[super JSONKeyPathsByPropertyKey] parameters:parameters];
}

@end

@implementation SyncanoParameters_Folders_Delete

- (NSString *)methodName {
	return @"folder.delete";
}



@end
