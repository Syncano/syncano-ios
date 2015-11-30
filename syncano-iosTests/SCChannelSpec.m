//
//  SCAPISpec.m
//  syncano4-ios
//
//  Created by Jan Lipmann on 27/03/15.
//  Copyright (c) 2015 Syncano. All rights reserved.
//

#import "Kiwi.h"
#import "Syncano.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "OHPathHelpers.h"
#import "SCJSONHelper.h"

@interface ChannelDelegateObject : NSObject<SCChannelDelegate>
@property (nonatomic,retain) SCChannelNotificationMessage *notificationMessage;
@end
@implementation ChannelDelegateObject
- (void)chanellDidReceivedNotificationMessage:(SCChannelNotificationMessage *)notificationMessage {
    self.notificationMessage = notificationMessage;
}
@end

SPEC_BEGIN(SCChannelSpec)

describe(@"SCChannel", ^{
    it(@"should init with name", ^{
        SCChannel *channel = [[SCChannel alloc] initWithName:@"CHANNEL-NAME"];
        [[channel.name should] equal:@"CHANNEL-NAME"];
    });
    
    it(@"should init with name and delegate", ^{
        ChannelDelegateObject *delegateObject = [ChannelDelegateObject new];
        SCChannel *channel = [[SCChannel alloc] initWithName:@"CHANNEL-NAME" andDelegate:delegateObject];
        [[channel.name should] equal:@"CHANNEL-NAME"];
        [[channel.delegate.class should] equal:[ChannelDelegateObject class]];
    });
    
    it(@"should init with name, lastId and delegate", ^{
        ChannelDelegateObject *delegateObject = [ChannelDelegateObject new];
        SCChannel *channel = [[SCChannel alloc] initWithName:@"CHANNEL-NAME" lastId:@12 andDelegate:delegateObject];
        [[channel.name should] equal:@"CHANNEL-NAME"];
        [[channel.lastId should] equal:@12];
        [[channel.delegate.class should] equal:[ChannelDelegateObject class]];
    });
    
    it(@"should init with name, room and delegate", ^{
        ChannelDelegateObject *delegateObject = [ChannelDelegateObject new];
        SCChannel *channel = [[SCChannel alloc] initWithName:@"CHANNEL-NAME" room:@"ROOM-NAME" andDelegate:delegateObject];
        [[channel.name should] equal:@"CHANNEL-NAME"];
        [[channel.room should] equal:@"ROOM-NAME"];
        [[channel.delegate.class should] equal:[ChannelDelegateObject class]];
    });
    
    it(@"should init with name, lastId, room and delegate", ^{
        ChannelDelegateObject *delegateObject = [ChannelDelegateObject new];
        SCChannel *channel = [[SCChannel alloc] initWithName:@"CHANNEL-NAME" lastId:@12 room:@"ROOM-NAME" andDelegate:delegateObject];
        [[channel.name should] equal:@"CHANNEL-NAME"];
        [[channel.lastId should] equal:@12];
        [[channel.room should] equal:@"ROOM-NAME"];
        [[channel.delegate.class should] equal:[ChannelDelegateObject class]];
    });
    
    context(@"SCChannelNotificationMessage", ^{
        it(@"should initiate from JSON object", ^{
            id JSON = [SCJSONHelper JSONObjectFromFileWithName:@"ChannelNotificationMessage"];
            SCChannelNotificationMessage *message = [[SCChannelNotificationMessage alloc] initWithJSONObject:JSON];
            [[message.author[@"admin"] should] equal:@1379];
            [[theValue(message.action) should] equal:theValue(SCChannelNotificationMessageActionCreate)];
            [[message.payload[@"id"] should] equal:@6];
            [[message.metadata[@"type"] should] equal:@"object"];
        });
    });
    
    context(@"singleton Syncano instance", ^{
        ChannelDelegateObject *delegateObject = [ChannelDelegateObject new];
        
        beforeAll(^{
           [Syncano sharedInstanceWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
        });
        
        beforeEach(^{
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                return YES;
            } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"ChannelNotificationMessage.json",self.class)
                                                        statusCode:200 headers:@{@"Content-Type":@"application/json"}];
            }];
        });
        
        it(@"should subscribe to channel", ^{
            SCChannel *channel = [[SCChannel alloc] initWithName:@"CHANNEL-NAME" lastId:@12 room:@"ROOM-NAME" andDelegate:delegateObject];
            [channel subscribeToChannel];
            [[expectFutureValue(delegateObject.notificationMessage) shouldEventually] beNonNil];
            [[delegateObject.notificationMessage.identifier should] equal:channel.lastId];
        });
        
        it(@"should publish to channel", ^{
            
            __block SCChannelNotificationMessage *_notificationMessage;
            __block NSError *_error;
            __block BOOL _blockFinished;
            
            SCChannel *channel = [[SCChannel alloc] initWithName:@"CHANNEL-NAME"];
            [channel publishToChannelWithPayload:@{@"content":@"hello!"} completion:^(SCChannelNotificationMessage *notificationMessage, NSError *error) {
                _error = error;
                _notificationMessage = notificationMessage;
                _blockFinished = YES;
                
            }];
            [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
            [[_error shouldEventually] beNil];
            [[_notificationMessage.identifier shouldEventually] equal:@1];
        });
        
        context(@"custom Syncano instance", ^{
            Syncano *syncano = [Syncano newSyncanoWithApiKey:@"API-KEY" instanceName:@"INSTANCE-NAME"];
            
            beforeEach(^{
                [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                    return YES;
                } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
                    return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"ChannelNotificationMessage.json",self.class)
                                                            statusCode:200 headers:@{@"Content-Type":@"application/json"}];
                }];
            });
            
            it(@"should subscribe to channel", ^{
                ChannelDelegateObject *delegateObject = [ChannelDelegateObject new];

                SCChannel *channel = [[SCChannel alloc] initWithName:@"CHANNEL-NAME" lastId:@12 room:@"ROOM-NAME" andDelegate:delegateObject];
                [channel subscribeToChannelInSyncano:syncano];
                [[expectFutureValue(delegateObject.notificationMessage) shouldEventually] beNonNil];
                [[delegateObject.notificationMessage.identifier should] equal:channel.lastId];
            });
            
            it(@"should publish to channel", ^{
                
                __block SCChannelNotificationMessage *_notificationMessage;
                __block NSError *_error;
                __block BOOL _blockFinished;
                
                SCChannel *channel = [[SCChannel alloc] initWithName:@"CHANNEL-NAME"];
                [channel publishToChannelInSyncano:syncano withPayload:@{@"content":@"hello!"} completion:^(SCChannelNotificationMessage *notificationMessage, NSError *error) {
                    _error = error;
                    _notificationMessage = notificationMessage;
                    _blockFinished = YES;
                    
                }];
                [[expectFutureValue(theValue(_blockFinished)) shouldEventually] beYes];
                [[_error shouldEventually] beNil];
                [[_notificationMessage.identifier shouldEventually] equal:@1];
            });
        });
    });
});

SPEC_END
