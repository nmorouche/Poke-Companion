import XCTest
@testable import AppRouter

@MainActor
final class AppRouterTests: XCTestCase {
    var router: AppRouter<Tab, Destination, Sheet>!

    override func setUp() async throws {
        router = AppRouter(initialTab: .home)
    }

    override func tearDown() async throws {
        router = nil
    }

    // MARK: - Tab and Navigation Logic

    func testRouterStartsInHomeState() {
        XCTAssertTrue(router.selectedTabPath.isEmpty)
        XCTAssertEqual(router.selectedTab, .home)
        XCTAssertNil(router.presentedSheet)
    }

    func testAddingDestinationsIncreasesPath() {
        router.navigateTo(.all)
        XCTAssertEqual(router.selectedTabPath, [.all])
        router.navigateTo(.note("abc"))
        XCTAssertEqual(router.selectedTabPath.count, 2)
        XCTAssertEqual(router.selectedTabPath[1], .note("abc"))
    }

    func testSingleAndMultiplePops() {
        router.navigateTo(.note("foo"))
        router.navigateTo(.all)
        XCTAssertEqual(router.selectedTabPath.count, 2)
        router.popNavigation()
        XCTAssertEqual(router.selectedTabPath, [.note("foo")])
        router.popNavigation()
        XCTAssert(router.selectedTabPath.isEmpty)
    }

    func testResettingToRootRemovesAllDestinations() {
        router.navigateTo(.all)
        router.navigateTo(.note("root"))
        XCTAssertFalse(router.selectedTabPath.isEmpty)
        router.popToRoot()
        XCTAssertEqual(router.selectedTabPath, [])
    }

    func testTabsKeepSeparateNavigationStacks() {
        router.navigateTo(.note("h1"), for: .home)
        router.navigateTo(.all, for: .profile)
        XCTAssert(router[.home] == [.note("h1")])
        XCTAssert(router[.profile] == [.all])
        XCTAssertTrue(router[.settings].isEmpty)
    }

    func testOpeningAndClosingSheetBehavior() {
        router.presentSheet(.settings)
        XCTAssert(router.presentedSheet == .settings)
        router.dismissSheet()
        XCTAssert(router.presentedSheet == nil)
    }

    func testSwitchingTabsClearsActiveNavigationStack() {
        router.selectedTab = .profile
        router.navigateTo(.all)
        XCTAssertEqual(router.selectedTab, .profile)
        XCTAssertFalse(router.selectedTabPath.isEmpty)
        router.selectedTab = .home
        XCTAssert(router.selectedTabPath.isEmpty)
        XCTAssert(router[.profile] == [.all])
    }

    // MARK: - Deeplink and URL Routing

    func testSinglePathDeeplink() {
        let navigated = router.navigate(to: "routingapp://all")
        XCTAssertTrue(navigated)
        XCTAssertEqual(router.selectedTabPath, [.all])
    }

    func testArticleDeeplinkWithId() {
        let didNavigate = router.navigate(to: "routingapp://article/id?id=42")
        XCTAssertTrue(didNavigate)
        guard let last = router.selectedTabPath.last else {
            XCTFail("Navigation stack should not be empty"); return
        }
        XCTAssertEqual(last, .article("42"))
    }

    func testNoteDeeplinkWithId() {
        let didNavigate = router.navigate(to: "routingapp://note?id=testNote")
        XCTAssertTrue(didNavigate)
        XCTAssertEqual(router.selectedTabPath, [.note("testNote")])
    }

    func testNoteDeeplinkWithNoId() {
        let didNavigate = router.navigate(to: "routingapp://note")
        XCTAssertTrue(didNavigate)
        XCTAssertEqual(router.selectedTabPath, [.note("default")])
    }

    func testRejectsUnknownDeeplink() {
        let result = router.navigate(to: "routingapp://notfound")
        XCTAssertFalse(result)
        XCTAssert(router.selectedTabPath.isEmpty)
    }

    func testRejectsMalformedURL() {
        let didHandle = router.navigate(to: "Everything but not a URL")
        XCTAssertFalse(didHandle)
        XCTAssert(router.selectedTabPath.isEmpty)
    }

    func testRejectsURLWithNoHost() {
        let didHandle = router.navigate(to: "routingapp://")
        XCTAssertFalse(didHandle)
        XCTAssert(router.selectedTabPath.isEmpty)
    }

    func testMultiSegmentDeeplink() {
        let ok = router.navigate(to: "routingapp://article/id?id=abc")
        XCTAssertTrue(ok)
        XCTAssert(router.selectedTabPath.count == 1)
        XCTAssertEqual(router.selectedTabPath[0], .article("abc"))
    }

    // MARK: - Destination.from Tests

    func testDestinationFrom_all() {
        let result = Destination.from(path: "all", fullPath: ["all"], parameters: [:])
        XCTAssertEqual(result, .all)
    }

    func testDestinationFrom_articleWithId() {
        let result = Destination.from(path: "id", fullPath: ["article", "id"], parameters: ["id": "42"])
        XCTAssertEqual(result, .article("42"))
    }

    func testDestinationFrom_noteWithId() {
        let result = Destination.from(path: "note", fullPath: ["note"], parameters: ["id": "note1"])
        XCTAssertEqual(result, .note("note1"))
    }

    func testDestinationFrom_noteWithNoId() {
        let result = Destination.from(path: "note", fullPath: ["note"], parameters: [:])
        XCTAssertEqual(result, .note("default"))
    }

    func testDestinationFrom_invalidPath() {
        let result = Destination.from(path: "unknown", fullPath: ["unknown"], parameters: [:])
        XCTAssertNil(result)
    }
}
