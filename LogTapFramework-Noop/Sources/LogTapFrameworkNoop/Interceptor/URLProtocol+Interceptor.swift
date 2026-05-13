//
//  URLProtocol+Interceptor.swift (Noop)
//

import Foundation

public final class LogTapURLProtocol: URLProtocol {
    public override class func canInit(with request: URLRequest) -> Bool { false }
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    public override func startLoading() {}
    public override func stopLoading() {}
}
