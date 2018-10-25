import XCTest
@testable import Bonsai

class Tests: XCTestCase {
 
    class StubDriver: BonsaiDriver {
        var callcount = 0
        func log(level: LogLevel, _ message: String, file: String, function: String, line: Int) {
            callcount += 1
        }
    }
    
    override func tearDown() {
        super.tearDown()
        Bonsai.resetDrivers()
    }
    
    func testRegisteringMultipleDrivers() {
        let driver = StubDriver()
        let driver2 = StubDriver()
        
        Bonsai.register(driver: driver)
        
        XCTAssertEqual(Bonsai.drivers.count, 1)
        
        Bonsai.register(driver: driver2)
        
        XCTAssertEqual(Bonsai.drivers.count, 2)
    }
    
    func testCannotRegisterSameDriverMultipleTimes() {
        let driver = StubDriver()
        
        Bonsai.register(driver: driver)
        Bonsai.register(driver: driver)
        
        XCTAssertEqual(Bonsai.drivers.count, 1)
    }
    
    func testDriverCalledWhenLogging() {
        let driver = StubDriver()
        Bonsai.register(driver: driver)
        
        "".log(.verbose)
        
        XCTAssertEqual(driver.callcount, 1)
    }
    
    func testDebugFocus() {
        let driver = StubDriver()
        Bonsai.debugFocusEnabled = true
        Bonsai.register(driver: driver)
        
        "".log(.error)
        "".log(.verbose)
        "".log(.warning)
        
        XCTAssertEqual(driver.callcount, 0)
    }
    
}
