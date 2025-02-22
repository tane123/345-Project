//
//  COSC345_ProjectTests.swift
//  COSC345-ProjectTests
//
//  Created by Hunter Kingsbeer on 14/05/21.
//

import XCTest
import CoreData
@testable import COSC345_Project

class COSC345_ProjectTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReceipt() throws {
        var image = [UIImage()]
        var image2 =  UIImage()
        let recognizedContent = RecognizedContent()
        let bundle = Bundle(for: COSC345_ProjectTests.self)
        var generatedString = ""
        var testString = ""
        var recepit = Receipt();
        //var documentView = DocumentScannerView()
        
            // Fetch Image Data
        if let path = bundle.path(forResource: "testRec", ofType: "jpg"){
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                image[0] = UIImage.init(data: data)!
                image2 = UIImage.init(data: data)!
//                print(image[0]) // checking if it is storing the image or not, it will print the size
            } catch {
                debugPrint("local picture missing")
                
            }
        }
    
        ScanTranslation(scannedImages: image, recognizedContent: recognizedContent){
            generatedString = recognizedContent.items[0].text
            print("GENERATED STRING:\n------------\n\(generatedString)\n------------\n")
        }.recognizeTextDebug()
        print()
        
        if let path = bundle.path(forResource: "test", ofType: "txt"){
            do {
                testString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                print("TEST STRING:\n------------\n\(testString)\n------------\n") // checking if it is storing the image or not, it will print the size
            } catch {
                debugPrint("local file missing")
                
            }
        
        print(recognizedContent.items)
        XCTAssert(generatedString == testString)
        
        Receipt.saveScan(recognizedText: generatedString, image: image2)
        recepit = Receipt.getReceipt(title: "Blond")
        let splitString = generatedString.components(separatedBy: CharacterSet.newlines).first!
        print(splitString)
        XCTAssert(splitString == recepit.title?.lowercased())
             var preview: PersistenceController = {
                let result = PersistenceController(inMemory: true)
                let viewContext = result.container.viewContext
                
                for folder in Folder.folders {
                    let newFolder = Folder(context: viewContext)
                    newFolder.title = folder.title.capitalized
                    newFolder.color = folder.color
                    newFolder.icon = folder.icon
                    newFolder.id = UUID()
                }
                
                 PersistenceController.save(viewContext: viewContext)
                
                for index in 0..<10 {
                    let newReceipt = Receipt(context: viewContext)
                    newReceipt.body = "BODY TEXT EXAMPLE"
                    newReceipt.date = Date()
                    newReceipt.id = UUID()
                    newReceipt.title = "Example Store"
                    newReceipt.folder = Prediction.pointPrediction(text: ((newReceipt.title ?? "") + (newReceipt.body ?? "")))
                }
                        
                 PersistenceController.save(viewContext: viewContext)
                return result
            }()
            XCTAssert(PersistenceController.preview.getContext() != preview.getContext() )
        }
    }
    
    /**
     Checks if the recpits are being stored and fetched in folders correctly
     */
    func testFolders() throws {
        let scans = ["Cotton On", "Jb Hifi", "Countdown", "Invoice"]
        Receipt.generateKnownReceipts()
        var count = 0
        for receipt in Receipt.getReceipts() {
            XCTAssert(scans.contains(receipt.title ?? ""))
            if count < scans.count-1 {
                count += 1
            } else {
                break
            }
        }
    }
    
}
