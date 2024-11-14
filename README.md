# swift-doro-webdav-client
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fchengang%2Fswift-doro-webdav-client%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/chengang/swift-doro-webdav-client)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fchengang%2Fswift-doro-webdav-client%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/chengang/swift-doro-webdav-client)
    
Lightweight WebDAV client for macOS sans XML library dependencies

## SYNOPSIS

```swift
let baseUrl = "http://192.168.50.55:81/dav/"
let usr = "user"
let passwd = "password"

let wd = DoroWebDAVClient(baseUrl: baseUrl, usr: usr, passwd: passwd)
let fileData = "Hello, World!".data(using: .utf8)!

//
// Upload
//
// curl --user 'aaa:aaa' -T t1 http://192.168.50.55:81/dav/t1
//

await Task {
    let ret = await wd.write("http://192.168.50.55:81/dav/doroTestFile", data: fileData)
    dump(ret)
}.value
    
//
// Read
//
// curl --user 'aaa:aaa' http://192.168.50.55:81/dav/t1
//

await Task {
    let ret = await wd.read("http://192.168.50.55:81/dav/doroTestFile")
    print(String(data: ret!, encoding: .utf8)!)
}.value
        
//
// List
//
// curl --user 'aaa:aaa' -X PROPFIND -H "Depth: 1" http://192.168.50.55:81/dav/
//

await Task {
    let ret = await wd.list()
    dump(ret)
}.value

//
// Delete
//
// curl --user 'aaa:aaa' -X DELETE http://192.168.50.55:81/dav/t1
//

await Task {
    let ret = await wd.delete("http://192.168.50.55:81/dav/doroTestFile")
    dump(ret)
}.value
```


## Testing
1. Set your WebDAV server info in `swift_doro_webdav_clientTests.swift` before testing.
2. Check that you have necessary permissions on your WebDAV server before testing.
3. Already Tested against `lighttpd-mod-webdav`.
