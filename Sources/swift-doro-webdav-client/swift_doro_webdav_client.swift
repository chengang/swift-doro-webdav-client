import Foundation
import OSLog

public class DoroWebDAVClient {
    let baseUrl: String
    let currentUrl: String
    let usr: String
    let passwd: String
    
    public init(baseUrl: String, usr: String, passwd: String) {
        self.baseUrl = baseUrl
        self.currentUrl = baseUrl
        self.usr = usr
        self.passwd = passwd
    }
    
    private func urlRequestSetAuth(_ request: inout URLRequest) {
        let credentials = "\(self.usr):\(self.passwd)"
        let authData = credentials.data(using: .utf8)!
        let base64AuthData = authData.base64EncodedString()
        request.setValue("Basic \(base64AuthData)", forHTTPHeaderField: "Authorization")
    }

    private func getFileInfoDFS(_ nodes: [XMLNode]) -> [String: String] {
        var stack: [XMLNode] = nodes
        var result: [String: String] = [:]

        while !stack.isEmpty {
            if let currentNode = stack.popLast() 
            {
                if currentNode.childCount <= 1,
                    let name = currentNode.localName,
                    let value = currentNode.stringValue
                {
                    result[name] = value
                }

                if let children = currentNode.children {
                    stack.append(contentsOf: children.reversed())
                }
            } else {
                break
            }
        }
        return result
    }

    public func list() async -> [[String: String]]? {
        guard let url = URL(string: self.currentUrl) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PROPFIND"
        request.setValue("1", forHTTPHeaderField: "Depth")
        self.urlRequestSetAuth(&request)

        do {
            var retFiles: [[String: String]] = []
            let (xmlData, _) = try await URLSession(configuration: .ephemeral).data(for: request)
            let xmlTree = try XMLDocument(data: xmlData)

            for node in xmlTree.rootElement()!.children! {
                if "response" == node.localName! {
                    let retNode: [String: String] = getFileInfoDFS(node.children!)
                    retFiles.append(retNode)
                }
            }
            return retFiles
        } catch {
            return nil
        }
    }

    public func read(_ urlString: String) async -> Data? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        self.urlRequestSetAuth(&request)

        do {
            let (fileData, response) = try await URLSession(configuration: .ephemeral).data(for: request)

            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 {
                return fileData
            }
            return nil
        } catch {
            return nil
        }
    }

    public func write(_ urlString: String, data: Data) async -> Bool {
        guard let url = URL(string: urlString) else {
            return false
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        self.urlRequestSetAuth(&request)

        do {
            let (_, response) = try await URLSession(configuration: .ephemeral).upload(for: request, from: data)

            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 {
                return true
            }
            return false
        } catch {
            return false
        }
    }

    public func delete(_ urlString: String) async -> Bool {
        guard let url = URL(string: urlString) else {
            return false
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        self.urlRequestSetAuth(&request)
        
        do {
            let (_, response) = try await URLSession(configuration: .ephemeral).data(for: request)

            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 {
                return true
            }
            return false
        } catch {
            return false
        }
    }
}
