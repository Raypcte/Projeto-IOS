#if canImport(SytemConfiguration)

@testable import Alamofire
import Foundation
import SystemConfiguration
import XCTest

final class NetworkReachabilityManagerTestCase: BaseTestCase {
    // MARK: - Tests - Initialization

    func testThatManagerCanBeInitializedFromHost() {
        // Given, When
        let manager = NetworkReachabilityManager(host: "localhost")

        // Then
        XCTAssertNotNil(manager)
    }

    func testThatManagerCanBeInitializedFromAddress() {
        // Given, When
        let manager = NetworkReachabilityManager()

        // Then
        XCTAssertNotNil(manager)
    }

    func testThatHostManagerIsReachableOnWiFi() {
        // Given, When
        let manager = NetworkReachabilityManager(host: "localhost")

        // Then
        XCTAssertEqual(manager?.status, .reachable(.ethernetOrWiFi))
        XCTAssertEqual(manager?.isReachable, true)
        XCTAssertEqual(manager?.isReachableOnCellular, false)
        XCTAssertEqual(manager?.isReachableOnEthernetOrWiFi, true)
    }

    func testThatHostManagerStartsWithReachableStatus() {
        // Given, When
        let manager = NetworkReachabilityManager(host: "localhost")

        // Then
        XCTAssertEqual(manager?.status, .reachable(.ethernetOrWiFi))
        XCTAssertEqual(manager?.isReachable, true)
        XCTAssertEqual(manager?.isReachableOnCellular, false)
        XCTAssertEqual(manager?.isReachableOnEthernetOrWiFi, true)
    }

    func testThatAddressManagerStartsWithReachableStatus() {
        // Given, When
        let manager = NetworkReachabilityManager()

        // Then
        XCTAssertEqual(manager?.status, .reachable(.ethernetOrWiFi))
        XCTAssertEqual(manager?.isReachable, true)
        XCTAssertEqual(manager?.isReachableOnCellular, false)
        XCTAssertEqual(manager?.isReachableOnEthernetOrWiFi, true)
    }

    func testThatZeroManagerCanBeProperlyRestarted() {
        // Given
        let manager = NetworkReachabilityManager()
        let first = expectation(description: "first listener notified")
        let second = expectation(description: "second listener notified")

        // When
        manager?.startListening { _ in
            first.fulfill()
        }
        wait(for: [first], timeout: timeout)

        manager?.stopListening()

        manager?.startListening { _ in
            second.fulfill()
        }
        wait(for: [second], timeout: timeout)

        // Then
        XCTAssertEqual(manager?.status, .reachable(.ethernetOrWiFi))
    }

    func testThatHostManagerCanBeProperlyRestarted() {
        // Given
        let manager = NetworkReachabilityManager(host: "localhost")
        let first = expectation(description: "first listener notified")
        let second = expectation(description: "second listener notified")

        // When
        manager?.startListening { _ in
            first.fulfill()
        }
        wait(for: [first], timeout: timeout)

        manager?.stopListening()

        manager?.startListening { _ in
            second.fulfill()
        }
        wait(for: [second], timeout: timeout)

        // Then
        XCTAssertEqual(manager?.status, .reachable(.ethernetOrWiFi))
    }

    func testThatHostManagerCanBeDeinitialized() {
        // Given
        let expect = expectation(description: "reachability queue should clear")
        var manager: NetworkReachabilityManager? = NetworkReachabilityManager(host: "localhost")
        weak var weakManager = manager

        // When
        manager?.startListening(onUpdatePerforming: { _ in })
        manager?.stopListening()
        manager?.reachabilityQueue.async { expect.fulfill() }
        manager = nil

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNil(manager, "strong reference should be nil")
        XCTAssertNil(weakManager, "weak reference should be nil")
    }

    func testThatAddressManagerCanBeDeinitialized() {
        // Given
        let expect = expectation(description: "reachability queue should clear")
        var manager: NetworkReachabilityManager? = NetworkReachabilityManager()
        weak var weakManager = manager

        // When
        manager?.startListening(onUpdatePerforming: { _ in })
        manager?.stopListening()
        manager?.reachabilityQueue.async { expect.fulfill() }
        manager = nil

        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertNil(manager, "strong reference should be nil")
        XCTAssertNil(weakManager, "weak reference should be nil")
    }

    // MARK: - Listener

    func testThatHostManagerIsNotifiedWhenStartListeningIsCalled() {
        // Given
        guard let manager = NetworkReachabilityManager(host: "store.apple.com") else {
            XCTFail("manager should NOT be nil")
            return
        }

        let expectation = self.expectation(description: "listener closure should be executed")
        var networkReachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus?

        // When
        manager.startListening { status in
            guard networkReachabilityStatus == nil else { return }
            networkReachabilityStatus = status
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertEqual(networkReachabilityStatus, .reachable(.ethernetOrWiFi))
    }

    func testThatAddressManagerIsNotifiedWhenStartListeningIsCalled() {
        // Given
        let manager = NetworkReachabilityManager()
        let expectation = self.expectation(description: "listener closure should be executed")

        var networkReachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus?

        // When
        manager?.startListening { status in
            networkReachabilityStatus = status
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout)

        // Then
        XCTAssertEqual(networkReachabilityStatus, .reachable(.ethernetOrWiFi))
    }

    // MARK: - NetworkReachabilityStatus

    func testThatStatusIsNotReachableStatusWhenReachableFlagIsAbsent() {
        // Given
        let flags: SCNetworkReachabilityFlags = [.connectionOnDemand]

        // When
        let status = NetworkReachabilityManager.NetworkReachabilityStatus(flags)

        // Then
        XCTAssertEqual(status, .notReachable)
    }

    func testThatStatusIsNotReachableStatusWhenConnectionIsRequired() {
        // Given
        let flags: SCNetworkReachabilityFlags = [.reachable, .connectionRequired]

        // When
        let status = NetworkReachabilityManager.NetworkReachabilityStatus(flags)

        // Then
        XCTAssertEqual(status, .notReachable)
    }

    func testThatStatusIsNotReachableStatusWhenInterventionIsRequired() {
        // Given
        let flags: SCNetworkReachabilityFlags = [.reachable, .connectionRequired, .interventionRequired]

        // When
        let status = NetworkReachabilityManager.NetworkReachabilityStatus(flags)

        // Then
        XCTAssertEqual(status, .notReachable)
    }

    func testThatStatusIsReachableOnWiFiStatusWhenConnectionIsNotRequired() {
        // Given
        let flags: SCNetworkReachabilityFlags = [.reachable]

        // When
        let status = NetworkReachabilityManager.NetworkReachabilityStatus(flags)

        // Then
        XCTAssertEqual(status, .reachable(.ethernetOrWiFi))
    }

    func testThatStatusIsReachableOnWiFiStatusWhenConnectionIsOnDemand() {
        // Given
        let flags: SCNetworkReachabilityFlags = [.reachable, .connectionRequired, .connectionOnDemand]

        // When
        let status = NetworkReachabilityManager.NetworkReachabilityStatus(flags)

        // Then
        XCTAssertEqual(status, .reachable(.ethernetOrWiFi))
    }

    func testThatStatusIsReachableOnWiFiStatusWhenConnectionIsOnTraffic() {
        // Given
        let flags: SCNetworkReachabilityFlags = [.reachable, .connectionRequired, .connectionOnTraffic]

        // When
        let status = NetworkReachabilityManager.NetworkReachabilityStatus(flags)

        // Then
        XCTAssertEqual(status, .reachable(.ethernetOrWiFi))
    }

    #if os(iOS) || os(tvOS)
    func testThatStatusIsReachableOnCellularStatusWhenIsWWAN() {
        // Given
        let flags: SCNetworkReachabilityFlags = [.reachable, .isWWAN]

        // When
        let status = NetworkReachabilityManager.NetworkReachabilityStatus(flags)

        // Then
        XCTAssertEqual(status, .reachable(.cellular))
    }

    func testThatStatusIsNotReachableOnCellularStatusWhenIsWWANAndConnectionIsRequired() {
        // Given
        let flags: SCNetworkReachabilityFlags = [.reachable, .isWWAN, .connectionRequired]

        // When
        let status = NetworkReachabilityManager.NetworkReachabilityStatus(flags)

        // Then
        XCTAssertEqual(status, .notReachable)
    }
    #endif
}

#endif
