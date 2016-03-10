# Local Storage

Using this feature you can easily store your object locally for future use. iOS Library is making all the magic to create proper database and store your objects inside.

## Saving Objects locally after fetch from syncano

Most common use of this functionality is storing fetched objects from syncano. It is very easy to perform this.

First you have to enable local storage. It is very important to run this method before you set a connection to Syncano instance
``` objective-c
[Syncano enableOfflineStorage];
[Syncano sharedInstanceWithApiKey:{API_KEY} instanceName:{INSTANCE_NAME}];
```

Now after you fetch your objects from syncano you can easily store them locally using special designed method

```objective-c
[[Book please] giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
    for (Book *book in objects) {
        [book saveToLocalStorageWithCompletion:^(NSError *error) {
        }];
    }
}];
```

That’s it. All your objects are stored locally on your device.


## Fetching objects from local storage

It is that simple as fetching objects from syncano
