import XCTest
@testable import swift_doro_webdav_client

final class swift_doro_webdav_clientTests: XCTestCase {
    let baseUrl = "http://192.168.50.55:81/dav/"
    let usr = "aaa"
    let passwd = "aaa"
    
    func testList() async throws {
        let client = DoroWebDAVClient(baseUrl: self.baseUrl, usr: self.usr, passwd: self.passwd)
        let ret = await client.list()
        let fileList = try XCTUnwrap(ret)
        XCTAssertGreaterThan(fileList.count, 1)
    }

    func testWriteThenReadThenDelete() async throws {
        let client = DoroWebDAVClient(baseUrl: self.baseUrl, usr: self.usr, passwd: self.passwd)
        let fileData = "Hello, World!".data(using: .utf8)!
        let testFilename = "\(self.baseUrl)doroTestFile"
        
        let ret0 = await client.write(testFilename, data: fileData)
        XCTAssertTrue(ret0)
        let ret1 = await client.read(testFilename)
        XCTAssertEqual(ret1, fileData)
        let ret2 = await client.delete(testFilename)
        XCTAssertTrue(ret2)
    }
}
