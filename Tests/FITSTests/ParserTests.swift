
import XCTest
@testable import FITS


final class ParserTests: XCTestCase {
    
    static var allTests = [
        ("testReadSimple", testReadSimple),
        ("testReadBitpix", testReadBitpix),
        ("testReadNaxis", testReadNaxis),
        ("testReadNaxisN", testReadNaxisN),
        ("testReadExtend", testReadExtend),
        ("testReadComment", testReadComment),
        ("testReadDate", testReadDate),
        ("testReadHDU", testReadHDU),
        ("testReadTDISP", testReadTDISP),
        ("testReadTFORM", testReadTFORM),
        ("testReadTFIELD", testReadTFIELD),
        ("testReadBFORM", testReadBFORM),
        ("testReadBFIELD", testReadBFIELD),
        ("testReadBFORM_VarArr",testReadBFORM_VarArr)
    ]
    
    func testReadSimple() {
        let text = "SIMPLE  =                    T / file does conform to FITS standard             "
        let block = HeaderBlock.parse(form: text)
        
        XCTAssertEqual(block.keyword, HDUKeyword.SIMPLE)
        XCTAssertTrue(block.value == true)
        XCTAssertEqual(block.comment, "file does conform to FITS standard")
        XCTAssertTrue(block.isSimple)
    }
    
    func testReadBitpix() {
        let text = "BITPIX  =                    8 / number of bits per data pixel                  "
        let block = HeaderBlock.parse(form: text)
        
        XCTAssertEqual(block.keyword, HDUKeyword.BITPIX)
        XCTAssertTrue(block.value == BITPIX.UINT8)
        XCTAssertEqual(block.comment, "number of bits per data pixel")
    }
    
    func testReadNaxis() {
        let text = "NAXIS   =                    3 / number of data axes                            "
        let block = HeaderBlock.parse(form: text)
        
        XCTAssertEqual(block.keyword, HDUKeyword.NAXIS)
        XCTAssertTrue(block.value == 3)
        XCTAssertEqual(block.comment, "number of data axes")
    }
    
    func testReadNaxisN() {
        let text = "NAXIS1  =                  480 / length of data axis 1                          "
        let block = HeaderBlock.parse(form: text)
        
        XCTAssertEqual(block.keyword, HDUKeyword.NAXIS+"1")
        XCTAssertTrue(block.value == 480)
        XCTAssertEqual(block.comment, "length of data axis 1")
        
        let text2 = "NAXIS1  =                89688 / length of first data axis                      "
        let block2 = HeaderBlock.parse(form: text2)
        
        XCTAssertEqual(block2.keyword, HDUKeyword.NAXIS+"1")
        XCTAssertTrue(block2.value == 89688)
        XCTAssertEqual(block2.comment, "length of first data axis")
    }
    
    func testReadExtend() {
        let text = "EXTEND  =                    T / FITS dataset may contain extensions            "
        let block = HeaderBlock.parse(form: text)
        
        XCTAssertEqual(block.keyword, "EXTEND")
        XCTAssertTrue(block.value == true)
        XCTAssertEqual(block.comment, "FITS dataset may contain extensions")
    }
    
    func testReadComment() {
        let text = "COMMENT   FITS (Flexible Image Transport System) format is defined in 'Astronomy"
        
        let block = HeaderBlock.parse(form: text)
        
        XCTAssertEqual(block.keyword, HDUKeyword.COMMENT)
        XCTAssertTrue(block.value == nil)
        XCTAssertEqual(block.comment, "FITS (Flexible Image Transport System) format is defined in 'Astronomy")
        XCTAssertTrue(block.isComment)
    }
    
    func testReadDate()  {
        let text = "DATE    = '2020-05-21T09:33:13' / UTC date that FITS file was created           "
        let block = HeaderBlock.parse(form: text)
        
        XCTAssertEqual(block.keyword, HDUKeyword.DATE)
        XCTAssertTrue(block.value == "2020-05-21T09:33:13", "\(block.value)")
        XCTAssertEqual(block.comment, "UTC date that FITS file was created")
    }
    
    func testReadAny()  {
        let text = "ANY     = 'Some Random Wording  ' / And acomment as well                           "
        let block = HeaderBlock.parse(form: text)
        
        XCTAssertEqual(block.keyword, "ANY")
        XCTAssertTrue(block.value == "Some Random Wording  ", "\(block.value)")
        XCTAssertEqual(block.comment, "And acomment as well")
    }

    func testReadHDU() {
        var data = Data(base64Encoded: SiriLSample)!

        guard let hdu = try? AnyHDU(with: &data) else {
            XCTFail("HDU must not be null")
            return
        }
        
        XCTAssertEqual(hdu.modified, false)
        XCTAssertEqual(hdu.headerUnit.count, 16)
        XCTAssertNotNil(hdu.dataUnit)
        XCTAssertEqual(hdu.bitpix, BITPIX.UINT8)
        XCTAssertEqual(hdu.naxis, 3)
        XCTAssertEqual(hdu.naxis(1), 480)
        XCTAssertEqual(hdu.naxis(2), 360)
        XCTAssertEqual(hdu.naxis(3), 3)
        XCTAssertEqual(hdu.dataSize, 518400)
        
    }
    
    func testReadTDISP() {
        let t1 = "D25.17"
        let t2 = "G15.7"
        let t3 = "A8"
        let t4 = "ES12.2"
        let t5 = "E6.6E2"
        let t6 = "E6e2"
        
        XCTAssertEqual(TDISP.parse(t1), TDISP.D(w: 25, d: 17, e: nil))
        XCTAssertEqual(TDISP.parse(t2), TDISP.G(w: 15, d: 7, e: nil))
        XCTAssertEqual(TDISP.parse(t3), TDISP.A(w: 8))
        XCTAssertEqual(TDISP.parse(t4), TDISP.ES(w: 12, d: 2))
        XCTAssertEqual(TDISP.parse(t5), TDISP.E(w: 6, d: 6, e: 2))
        XCTAssertEqual(TDISP.parse(t6), TDISP.E(w: 6, d: 0, e: 2))
    }
    
    func testReadTFORM() {
        let t1 = "E15.7"
        let t2 = "D25.17"
        let t3 = "A8"
        
        
        XCTAssertEqual(TFORM.parse(t1), TFORM.E(w: 15, d: 7))
        XCTAssertEqual(TFORM.parse(t2), TFORM.D(w: 25, d: 17))
        XCTAssertEqual(TFORM.parse(t3), TFORM.A(w: 8))
    }
    
    func testReadTFIELD() {
        let t1 = TFORM.A(w: 8)
        let f1 = TFIELD.parse(string: "Hello World", type: t1) as! TFIELD.A
        
        XCTAssertNotNil(f1)
        XCTAssertEqual(f1.val, "Hello World")
        
        let t2 = TFORM.I(w: 8)
        let f2 = TFIELD.parse(string: "1024", type: t2) as! TFIELD.I
        
        XCTAssertNotNil(f2)
        XCTAssertEqual(f2.val, 1024)
        
        let t3 = TFORM.F(w: 8, d: 2)
        let f3 = TFIELD.parse(string: "4096", type: t3) as! TFIELD.F
        
        XCTAssertNotNil(f3)
        XCTAssertEqual(f3.val, 4096.00)
        
        let t4 = TFORM.D(w: 8, d: 2)
        let f4 = TFIELD.parse(string: "2048", type: t4) as! TFIELD.D
        
        XCTAssertNotNil(f4)
        XCTAssertEqual(f4.val, 2048.00)
        
        let t5 = TFORM.E(w: 25, d: 7)
        let f5 = TFIELD.parse(string: "-6.11104586446241e-01", type: t5) as! TFIELD.E
        
        XCTAssertNotNil(f5)
        XCTAssertEqual(f5.val, -6.11104586446241e-01)
        
        let t6 = TFORM.E(w: 25, d: 7)
        let f6 = TFIELD.parse(string: "2.94289329828329E+01", type: t6) as! TFIELD.E
        
        XCTAssertNotNil(f6)
        XCTAssertEqual(f6.val, 2.94289329828329E01)
        
        let t7 = TFORM.D(w: 25, d: 7)
        let f7 = TFIELD.parse(string: "4.99471371062592860D+08", type: t7) as! TFIELD.D
        
        XCTAssertNotNil(f7)
        XCTAssertEqual(f7.val, 4.99471371062592860e+08)
        
    }
    
     func testReadBFORM() {
     
        let t1 = "5A      "
        let t2 = "1I      "
        let t3 = "640E    "
        
        XCTAssertEqual(BFORM.parse(t1), BFORM.A(r: 5))
        XCTAssertEqual(BFORM.parse(t2), BFORM.I(r: 1))
        XCTAssertEqual(BFORM.parse(t3), BFORM.E(r: 640))
    }
    
    func testReadBFIELD() {
        
        let t1 = Data(base64Encoded: "TEFSR0U=")
        let f1 = BFORM.A(r: 5)
        
        XCTAssertEqual(BFIELD.parse(data: t1, type: f1), BFIELD.A(val: "LARGE"))
        
        let t2 = Data(base64Encoded: "AoA=")
        let f2 = BFORM.I(r: 1)
        XCTAssertEqual(BFIELD.parse(data: t2, type: f2), BFIELD.I(val: [640]))
        
        let t3 = Data(base64Encoded: "RNrAAA==")
        let f3 = BFORM.E(r: 1)
        XCTAssertEqual(BFIELD.parse(data: t3, type: f3), BFIELD.E(val: [1750.0]))
        
        let t4 = Data(base64Encoded: "QQKWzsFS2AHB4hzQwUDVKj+FT7bAukFWwAUxwUIFM0BAZR/3QAXGe8I8hYzBaKJXQXfwacC6Y7lDAeeMw2srtsPjA4TB34iewod7+cIIvmLBLjxowXoaIsElWXBAmyoTQYmcJkGNF6TBVqa/vsBAWsGzu5XBoh+lwT+EXUErZ8xBZxFfQhyBaUGeSV9BoK1sv559FMFb8LY/f2WZQeYt7UH35CZBd+D9wGHkaEFFVVhBXIEzQPzrXUHWNv5BvCYoQGTXtUGq8F1CV/vcQinHy0HqA0JB3DAgQg1sukInKAdCQocfQinVa0K0R8BCjVCDQq1PJULBVDxCr6t+QqfR4EKk5qlCrQEfQrn650J/evZCntwOQkLVoUJ7/ghClfuEQnhO10K0zNFCiIzgQmfyVEKFOnZCU41IQkaEsUKeZhlCSp8nQoT1tEKMj8pCt2ONQqxVX0KKHLlB/4onQm79RUKZYZ1ClbnFQr0oKEI4MQxCeJUdQlslgUKE0klCZJ1gQnCy90Kc09VCpeYuQlTt6EJqe9xCugw3QpIZX0K7c95CkolPQlDxwUKMjcxCrI7OQouy10K9lRlC6lnnQp6+SULG+khCmz8qQodq8EJOcblCoXZJQp2JmUK9gbpCl+upQnSvaUKjq9FCzzxwQrojg0KpAxlCkrElQslqkELpSqJCx5fQQpXKiEKvgOlCq112QrrDh0LRW7hCn67EQsM7h0LCFr1CpcgnQpHo1kKaFVhCjcdaQovwI0KXdv5Cg0fmQqfszEJvV69CmVFQQroyWELNQoxCwB3SQq7ipUJmoEVCqeE7Quy3YUKaVy5C0iuRQs2bIEJETHJClIRGQomzPUJ4eg1CpBQmQsu69ELKzKdClPcBQr5X8EKqhvtCrJcKQpaZYkKBLXxCipI0Qn6ykEKXjDRClOumQo2Pa0LFsnlCuF77QlsDPUK26T9Cq5VfQp8K20KT7PRCsXSlQqPyWkKo6VBCrttuQtMH0EKYGABCiJKvQtKqHkKeUndCpWmBQmU52EK4Gq1CoKF/QqCH9ELKfSNCsSHgQnIDb0Kk39pCvvAJQrlt4ULZxglC+NU6Qp3xpkK9vOtC85U+QvE83EKx3GNC2vd+QuTilEK3znpCqmbCQsfdz0LFbi9C0eqBQtRvAkLscjtC8N4TQxlDeEMx4JNDK3hqQxZWpEMTURtDDfi6Qw8t1kMAE5NCrB5mQwKTUEL/5ZtDJZe0QwLw5ULm/w1DA5iAQxgLfkMKa7lDHVr3QwlAhULP3ZJDAhd9Qu9V50MNtfVDDCfbQyNlsEMle5tDOmWwQxu0UEM0v5xDIF3zQxZ8s0MPt0NDGgmkQyZzGUNFWMJDIQPGQ0ZVRkNi5LpDQEiLQ0KAs0My2AdDUi9EQ1LiBENp7TVDOLYRQ2ph9ENxCuhDVA4zQzi64kNzHapDYgAVQ17shkNHQdRDcIt+Q2hswUOB5zhDcUF5Q18TQkNaeadDainqQ2uD/ENYbQBDVYm6Q2yedkNsUn9DcNe+Q3fhZEOK5ARDff3XQ4o+k0OLkkxDi6A2Q3OBxUOHOLBDjc23Q4c2RkOCGthDnqEiQ4YAzEOJvCtDflFYQ3b52EOHHj9DdnBAQ4SyqkOHzXNDf2C2Q4lTyUOkq/FDiNLwQ5xAf0OXeTBDeXAbQ4rPb0OLVoZDlUAKQ2x+nkNUzgVDnZG4Q4cMRUN8HnhDdGUoQ4i6x0OE30xDlCBgQ4KXjUOHj4FDmrT/Q5IjhEO0BE5DoDn2Q7E8XUOS1TRDmtncQ7uB10OtiFFDuU0yQ6RiIUOl939Dt/JIQ7OShEOxFGBDtGdLQ6aJSUOePjlDvd/hQ66cjUOYrPFDpeVOQ67aNUOZ8XxDuVllQ5VKLUOesPpD09ZOQ7zDuUPF4v5Dsb6rQ7JgVEOkUytDr1LNQ7QlQUO03C1DokhXQ6K4SkO0sthDwwtHQ76WoEOp6PxDwKRTQ7WBLUPAdR1DwHZOQ7rm8UPMXD5DyIZXQ8KRB0O/nj9DzVtzQ7oDQUPce31D4GLmQ+euFkPWPY5D2aGjQ+q8RkPWwxlD2w+RQ/NVHUPt5FdD+GhdQ/nn0kPpVWVD+8E9RBIXKUPjKZND8OBiQ+RWokQCi4tECEK2RCQw/kQiBKxEMqlIRBn8mkQMVf9ECWKURA8VSkQPnDZD6qEwQ+ONqEPh24ND8pPPQ+fkDkPO7ttD2yodQ9vBK0O9bGRDsLDLQ8TMdkOw90NDvyEtQ7/OBUPG0BhDxeFHQ8sB4EPAnTxDuTEhQ9q8wkPBhdNDz9LwQ9AjGUPTTNtDzr9aQ8pnDEPR3ZlDyg/PQ8iPpkPNEAxD0xALQ8HaiEPQyClD1D2WQ9XeRkPSqZhDzNJtQ8x03kPDGmhDzr1PQ73sykO+ezFDwBazQ7OzA0OuSHJDvThhQ702LUPAHptDyNpYQ7x+LkOx2mdDqyjyQ5tsd0OZSj5Dnv0NQ6x49kOz1RpDqO4xQ5y9lkOh7S5DpQDDQ6lB/0OjwipDo8R1Q54LgEOK2PtDjcusQ5aH8UOP80JDij3dQ5rQC0OVPN9DhjgbQ4T+pkOXVTtDi5fyQ4J2zkOQPgxDiHBHQ42cdUORcEJDkHNQQ4YbC0NSOjtDamo5Q0XIDUNJrp1DcpNWQ1jywkNRTHBDZhRzQ2PXOENRDXFDX+j5Q2yrd0NrcXFDSzclQzZtSUMyqIxDJV1eQy5CfkMqzjhDJTxQQy9e+kMzJ+NDNRMBQzkmn0MouURDHs4WQyRZuEMygOFDNe3IQyviakMjg7tDGMCNQx4GtkMgOPJDIab2QxcqWkMWKJhC/VqDQvZNW0LjqctC55XqQvPR70L26QRC6tFWQs33I0LhCMRDBI+sQtq2JkLTqa9C3Cp8QtcSfELdFmBCyi8EQsfOLULM4gtCvgaJQpqTu0KNpZhCnUdFQqIjYEKXDEhCthgfQqpWM0KjJOtCpCKLQqs7qkKlVCFCqWugQqntekKlcEhCjXvPQoVXsUJ/tANCf1+hQoLCwkKcEAxCpj5rQpASXUKL8ulCj5MMQoeo3UKPHXtChelqQoVBy0KG8CJCieDQQntcT0KCFBlCgnOcQpAm00KCWtpCiCvGQpFjW0KM4zxChe71QmrIFUKNeF9Chj3ZQmbUykJXgiBCYgcSQkfX/0JIobJCQS6pQlVTTUJb+4FCZv83QmKFNUJCBEZCUROBQliUGUJgduBCg7VZQnQbGkJle25CY8v6QksEE0JIYJBCJfdJQhwLA0H67XJBy0+uQfZjFkH5GuVB4Os1QgKkgkG4V98AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==")
        let f4 = BFORM.E(r: 640)
        
        let b4 = BFIELD.parse(data: t4, type: f4) as! BFIELD.E
        XCTAssertEqual(b4.val?[0], 8.161818)
        XCTAssertEqual(b4.val?[639], 0.0)
        
        let t5 =  Data(base64Encoded: "//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADwAPAA8ADwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD//v/+//7//v/+//7//v/+//7//v/+//7//v/+//7//v3++P74/vj+uP6//r/+v/6//r/+v/6//r/+v/6//r/+v/6//r/+v/6//r/+v/4=")
        let f5 = BFORM.I(r: 640)
        
        let b5 = BFIELD.parse(data: t5, type: f5) as! BFIELD.I
        XCTAssertEqual(b5.val?[0], -2)
        XCTAssertEqual(b5.val?[639], -16386)
        
    }
    
    func testReadBFORM_VarArr() {
            
        let t1 = "PB(1800)"
        let x1 = BFORM.parse(t1)
        
        XCTAssertEqual(x1, BFORM.PB(r: 1800))
        XCTAssertEqual(BFIELD.PB(val: [0,1,2,3,4,5,6,7,8,9]).form, BFORM.PB(r: 10))
        
        let t2 = "PE(1800)"
        let x2 = BFORM.parse(t2)
        
        XCTAssertEqual(x2, BFORM.PE(r: 1800))
        XCTAssertEqual(BFIELD.PE(val: [0,1,2,3,4,5,6,7,8,9]).form, BFORM.PE(r: 10))
        
        let t3 = "PA(10)"
        let x3 = BFORM.parse(t3)
        
        XCTAssertEqual(x3, BFORM.PA(r: 10))
        XCTAssertEqual(BFIELD.PA(val: "0123456789").form, BFORM.PA(r: 10))
    }

}
