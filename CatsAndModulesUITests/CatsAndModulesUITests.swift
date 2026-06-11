//
//  CatsAndModulesUITests.swift
//  CatsAndModulesUITests
//
//  Created by alina on 04.06.2026.
//

import XCTest

@MainActor
final class CatsAndModulesUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    func testScreenshots() throws {
        let app = XCUIApplication()

        sleep(15)

        snapshot("AlinaKharchenko_MainScreen")

//        let firstCell = app.tables.cells.firstMatch
//        XCTAssertTrue(firstCell.waitForExistence(timeout: 30))
        
        print("Buttons count:", app.buttons.count)
        print("Cells count:", app.cells.count)
        print("Links count:", app.links.count)
        print(app.debugDescription)

        let firstCatElement = app.descendants(matching: .any)
            .matching(NSPredicate(format: "identifier BEGINSWITH %@", "cat_"))
            .firstMatch

        XCTAssertTrue(firstCatElement.waitForExistence(timeout: 30))
        firstCatElement.tap()

        snapshot("AlinaKharchenko_DetailsScreen")
    }

    override func tearDownWithError() throws {
    }
}
