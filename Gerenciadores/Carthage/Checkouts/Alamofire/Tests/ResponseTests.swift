import Alamofire
import Foundation
import XCTest

final class ResponseTestCase: BaseTestCase {
    func testThatResponseReturnsSuccessResultWithValidData() {
        // Given
        let expectation = self.expectation(description: "request should succeed")

        var response: DataResponse<Data?, AFError>?

        // When
        AF.request(.default, parameters: ["foo": "bar"]).response { resp in
            response = resp
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertNil(response?.error)
        XCTAssertNotNil(response?.metrics)
    }

    func testThatResponseReturnsFailureResultWithOptionalDataAndError() {
        // Given
        let urlString = String.invalidURL
        let expectation = self.expectation(description: "request should fail with invalid URL error")

        var response: DataResponse<Data?, AFError>?

        // When
        AF.request(urlString, parameters: ["foo": "bar"]).response { resp in
            response = resp
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNil(response?.response)
        XCTAssertNil(response?.data)
        XCTAssertNotNil(response?.error)
        XCTAssertEqual(response?.error?.isSessionTaskError, true)
        XCTAssertNotNil(response?.metrics)
    }
}

// MARK: -

final class ResponseDataTestCase: BaseTestCase {
    func testThatResponseDataReturnsSuccessResultWithValidData() {
        // Given
        let expectation = self.expectation(description: "request should succeed")

        var response: DataResponse<Data, AFError>?

        // When
        AF.request(.default, parameters: ["foo": "bar"]).responseData { resp in
            response = resp
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.result.isSuccess, true)
        XCTAssertNotNil(response?.metrics)
    }

    func testThatResponseDataReturnsFailureResultWithOptionalDataAndError() {
        // Given
        let urlString = String.invalidURL
        let expectation = self.expectation(description: "request should fail with invalid URL error")

        var response: DataResponse<Data, AFError>?

        // When
        AF.request(urlString, parameters: ["foo": "bar"]).responseData { resp in
            response = resp
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNil(response?.response)
        XCTAssertNil(response?.data)
        XCTAssertEqual(response?.result.isFailure, true)
        XCTAssertEqual(response?.error?.isSessionTaskError, true)
        XCTAssertNotNil(response?.metrics)
    }
}

// MARK: -

final class ResponseStringTestCase: BaseTestCase {
    func testThatResponseStringReturnsSuccessResultWithValidString() {
        // Given
        let expectation = self.expectation(description: "request should succeed")

        var response: DataResponse<String, AFError>?

        // When
        AF.request(.default, parameters: ["foo": "bar"]).responseString { resp in
            response = resp
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.result.isSuccess, true)
        XCTAssertNotNil(response?.metrics)
    }

    func testThatResponseStringReturnsFailureResultWithOptionalDataAndError() {
        // Given
        let urlString = String.invalidURL
        let expectation = self.expectation(description: "request should fail with invalid URL error")

        var response: DataResponse<String, AFError>?

        // When
        AF.request(urlString, parameters: ["foo": "bar"]).responseString { resp in
            response = resp
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNil(response?.response)
        XCTAssertNil(response?.data)
        XCTAssertEqual(response?.result.isFailure, true)
        XCTAssertEqual(response?.error?.isSessionTaskError, true)
        XCTAssertNotNil(response?.metrics)
    }
}

// MARK: -

@available(*, deprecated)
final class ResponseJSONTestCase: BaseTestCase {
    func testThatResponseJSONReturnsSuccessResultWithValidJSON() {
        // Given
        let expectation = self.expectation(description: "request should succeed")

        var response: DataResponse<Any, AFError>?

        // When
        AF.request(.default, parameters: ["foo": "bar"]).responseJSON { resp in
            response = resp
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.result.isSuccess, true)
        XCTAssertNotNil(response?.metrics)
    }

    func testThatResponseStringReturnsFailureResultWithOptionalDataAndError() {
        // Given
        let urlString = String.invalidURL
        let expectation = self.expectation(description: "request should fail")

        var response: DataResponse<Any, AFError>?

        // When
        AF.request(urlString, parameters: ["foo": "bar"]).responseJSON { resp in
            response = resp
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNil(response?.response)
        XCTAssertNil(response?.data)
        XCTAssertEqual(response?.result.isFailure, true)
        XCTAssertEqual(response?.error?.isSessionTaskError, true)
        XCTAssertNotNil(response?.metrics)
    }

    func testThatResponseJSONReturnsSuccessResultForGETRequest() {
        // Given
        let expectation = self.expectation(description: "request should succeed")

        var response: DataResponse<Any, AFError>?

        // When
        AF.request(.default, parameters: ["foo": "bar"]).responseJSON { resp in
            response = resp
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.result.isSuccess, true)
        XCTAssertNotNil(response?.metrics)

        if
            let responseDictionary = response?.result.success as? [String: Any],
            let args = responseDictionary["args"] as? [String: String] {
            XCTAssertEqual(args, ["foo": "bar"], "args should match parameters")
        } else {
            XCTFail("args should not be nil")
        }
    }

    func testThatResponseJSONReturnsSuccessResultForPOSTRequest() {
        // Given
        let expectation = self.expectation(description: "request should succeed")

        var response: DataResponse<Any, AFError>?

        // When
        AF.request(.method(.post), parameters: ["foo": "bar"]).responseJSON { resp in
            response = resp
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.result.isSuccess, true)
        XCTAssertNotNil(response?.metrics)

        if
            let responseDictionary = response?.result.success as? [String: Any],
            let form = responseDictionary["form"] as? [String: String] {
            XCTAssertEqual(form, ["foo": "bar"], "form should match parameters")
        } else {
            XCTFail("form should not be nil")
        }
    }
}

final class ResponseJSONDecodableTestCase: BaseTestCase {
    func testThatResponseDecodableReturnsSuccessResultWithValidJSON() {
        // Given
        let url = Endpoint().url
        let expectation = self.expectation(description: "request should succeed")

        var response: DataResponse<TestResponse, AFError>?

        // When
        AF.request(url, parameters: [:]).responseDecodable(of: TestResponse.self) { resp in
            response = resp
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.result.isSuccess, true)
        XCTAssertEqual(response?.result.success?.url, url.absoluteString)
        XCTAssertNotNil(response?.metrics)
    }

    func testThatResponseDecodableWithPassedTypeReturnsSuccessResultWithValidJSON() {
        // Given
        let url = Endpoint().url
        let expectation = self.expectation(description: "request should succeed")

        var response: DataResponse<TestResponse, AFError>?

        // When
        AF.request(url, parameters: [:]).responseDecodable(of: TestResponse.self) {
            response = $0
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.result.isSuccess, true)
        XCTAssertEqual(response?.result.success?.url, url.absoluteString)
        XCTAssertNotNil(response?.metrics)
    }

    func testThatResponseStringReturnsFailureResultWithOptionalDataAndError() {
        // Given
        let urlString = String.invalidURL
        let expectation = self.expectation(description: "request should fail")

        var response: DataResponse<TestResponse, AFError>?

        // When
        AF.request(urlString, parameters: [:]).responseDecodable(of: TestResponse.self) { resp in
            response = resp
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNil(response?.response)
        XCTAssertNil(response?.data)
        XCTAssertEqual(response?.result.isFailure, true)
        XCTAssertEqual(response?.error?.isSessionTaskError, true)
        XCTAssertNotNil(response?.metrics)
    }
}

// MARK: -

final class ResponseMapTestCase: BaseTestCase {
    func testThatMapTransformsSuccessValue() {
        // Given
        let expectation = self.expectation(description: "request should succeed")

        var response: DataResponse<String, AFError>?

        // When
        AF.request(.default, parameters: ["foo": "bar"]).responseDecodable(of: TestResponse.self) { resp in
            response = resp.map { response in
                response.args?["foo"] ?? "invalid"
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.result.isSuccess, true)
        XCTAssertEqual(response?.result.success, "bar")
        XCTAssertNotNil(response?.metrics)
    }

    func testThatMapPreservesFailureError() {
        // Given
        let urlString = String.invalidURL
        let expectation = self.expectation(description: "request should fail with invalid URL error")

        var response: DataResponse<String, AFError>?

        // When
        AF.request(urlString, parameters: ["foo": "bar"]).responseData { resp in
            response = resp.map { _ in "ignored" }
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNil(response?.response)
        XCTAssertNil(response?.data)
        XCTAssertEqual(response?.result.isFailure, true)
        XCTAssertEqual(response?.error?.isSessionTaskError, true)
        XCTAssertNotNil(response?.metrics)
    }
}

// MARK: -

final class ResponseTryMapTestCase: BaseTestCase {
    func testThatTryMapTransformsSuccessValue() {
        // Given
        let expectation = self.expectation(description: "request should succeed")

        var response: DataResponse<String, Error>?

        // When
        AF.request(.default, parameters: ["foo": "bar"]).responseDecodable(of: TestResponse.self) { resp in
            response = resp.tryMap { response in
                response.args?["foo"] ?? "invalid"
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.result.isSuccess, true)
        XCTAssertEqual(response?.result.success, "bar")
        XCTAssertNotNil(response?.metrics)
    }

    func testThatTryMapCatchesTransformationError() {
        // Given
        struct TransformError: Error {}

        let expectation = self.expectation(description: "request should succeed")

        var response: DataResponse<String, Error>?

        // When
        AF.request(.default, parameters: ["foo": "bar"]).responseData { resp in
            response = resp.tryMap { _ in
                throw TransformError()
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.result.isFailure, true)

        if let error = response?.result.failure {
            XCTAssertTrue(error is TransformError)
        } else {
            XCTFail("tryMap should catch the transformation error")
        }

        XCTAssertNotNil(response?.metrics)
    }

    func testThatTryMapPreservesFailureError() {
        // Given
        let urlString = String.invalidURL
        let expectation = self.expectation(description: "request should fail with invalid URL error")

        var response: DataResponse<String, Error>?

        // When
        AF.request(urlString, parameters: ["foo": "bar"]).responseData { resp in
            response = resp.tryMap { _ in "ignored" }
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNil(response?.response)
        XCTAssertNil(response?.data)
        XCTAssertEqual(response?.result.isFailure, true)
        XCTAssertEqual(response?.error?.asAFError?.isSessionTaskError, true)
        XCTAssertNotNil(response?.metrics)
    }
}

// MARK: -

enum TestError: Error {
    case error(error: AFError)
}

enum TransformationError: Error {
    case error

    func alwaysFails() throws -> TestError {
        throw TransformationError.error
    }
}

final class ResponseMapErrorTestCase: BaseTestCase {
    func testThatMapErrorTransformsFailureValue() {
        // Given
        let urlString = String.invalidURL
        let expectation = self.expectation(description: "request should not succeed")

        var response: DataResponse<TestResponse, TestError>?

        // When
        AF.request(urlString).responseDecodable(of: TestResponse.self) { resp in
            response = resp.mapError { error in
                TestError.error(error: error)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNil(response?.response)
        XCTAssertNil(response?.data)
        XCTAssertEqual(response?.result.isFailure, true)
        guard let error = response?.error, case .error = error else { XCTFail(); return }

        XCTAssertNotNil(response?.metrics)
    }

    func testThatMapErrorPreservesSuccessValue() {
        // Given
        let expectation = self.expectation(description: "request should succeed")

        var response: DataResponse<Data, TestError>?

        // When
        AF.request(.default).responseData { resp in
            response = resp.mapError { TestError.error(error: $0) }
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.result.isSuccess, true)
        XCTAssertNotNil(response?.metrics)
    }
}

// MARK: -

final class ResponseTryMapErrorTestCase: BaseTestCase {
    func testThatTryMapErrorPreservesSuccessValue() {
        // Given
        let expectation = self.expectation(description: "request should succeed")

        var response: DataResponse<Data, Error>?

        // When
        AF.request(.default).responseData { resp in
            response = resp.tryMapError { TestError.error(error: $0) }
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNotNil(response?.response)
        XCTAssertNotNil(response?.data)
        XCTAssertEqual(response?.result.isSuccess, true)
        XCTAssertNotNil(response?.metrics)
    }

    func testThatTryMapErrorCatchesTransformationError() {
        // Given
        let urlString = String.invalidURL
        let expectation = self.expectation(description: "request should fail")

        var response: DataResponse<Data, Error>?

        // When
        AF.request(urlString).responseData { resp in
            response = resp.tryMapError { _ in try TransformationError.error.alwaysFails() }
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNil(response?.response)
        XCTAssertNil(response?.data)
        XCTAssertEqual(response?.result.isFailure, true)

        if let error = response?.result.failure {
            XCTAssertTrue(error is TransformationError)
        } else {
            XCTFail("tryMapError should catch the transformation error")
        }

        XCTAssertNotNil(response?.metrics)
    }

    func testThatTryMapErrorTransformsError() {
        // Given
        let urlString = String.invalidURL
        let expectation = self.expectation(description: "request should fail")

        var response: DataResponse<Data, Error>?

        // When
        AF.request(urlString).responseData { resp in
            response = resp.tryMapError { TestError.error(error: $0) }
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNotNil(response?.request)
        XCTAssertNil(response?.response)
        XCTAssertNil(response?.data)
        XCTAssertEqual(response?.result.isFailure, true)
        XCTAssertNotNil(response?.metrics)
    }
}
