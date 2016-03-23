# Local Storage

Use Local Storage to easily store your object locally for future use. iOS Library does all the magic to set up a proper database and store your objects inside it.

## Saving Objects locally after fetching them from Syncano

Most common use case of this functionality, is storing objects fetched from Syncano.

First, you have to enable local storage feature. Run this method before you create a connection to your Syncano instance

**ObjectiveC:**
```objective-c
[Syncano enableOfflineStorage];
[Syncano sharedInstanceWithApiKey:{API_KEY} instanceName:{INSTANCE_NAME}];
```
**Swift:**
```swift
Syncano.enableOfflineStorage()
Syncano.sharedInstanceWithApiKey({API_KEY}, instanceName: {INSTANCE_NAME})
```

After you fetch your objects from Syncano, you can easily store them locally using `saveToLocalStorage` method

**ObjectiveC:**
```objective-c
[[Book please] giveMeDataObjectsWithCompletion:^(NSArray *objects, NSError *error) {
    for (Book *book in objects) {
        [book saveToLocalStorageWithCompletion:^(NSError *error) {
        }];
    }
}];
```
**Swift**
```swift
Book.please().giveMeDataObjectsWithCompletion { (objects, error) -> Void in
    for book:Book in objects as! [Book] {
        book.saveToLocalStorageWithCompletion({ (error) -> Void in

        })
    }
}
```

That’s it. All objects, on which you called `saveToLocalStorage` are now stored locally on your device.

## Fetching objects from local storage

Fetching objects from local storage is as simple as saving them in there

**ObjectiveC:**
```objective-c
[[Book please] giveMeDataObjectsFromLocalStorageCompletion:^(NSArray *objects, NSError *error) {
}];
```

**Swift:**
```swift
Book.please().giveMeDataObjectsFromLocalStorage { (objects, error) -> Void in        
}
```

You can also use predicate to query for specific objects

**ObjectiveC:**
```objective-c
SCPredicate *predicate = [SCPredicate whereKey:@"title" isEqualToString:@"Monte Cristo"];
[[Book please] giveMeDataObjectsFromLocalStorageWithPredicate:predicate completion:^(NSArray *objects, NSError *error) {
    _storedBook = [objects firstObject];
}];
```
**Swift:**
```swift
let predicate:SCPredicate = SCPredicate.whereKey("title", isEqualToString: "Monte Cristo")
Book.please().giveMeDataObjectsFromLocalStorageWithPredicate(predicate) { (objects, error) -> Void in    
}
```
