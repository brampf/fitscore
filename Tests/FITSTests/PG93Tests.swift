
import XCTest
@testable import FITS


final class PG93Tests: XCTestCase {
    
    static var allTests = [
        ("test_pg93_read00001", test_pg93_read00001),
        ("test_pg93_read00002", test_pg93_read00002),
        ("test_pg93_read00003", test_pg93_read00003),
        ("test_pg93_read00004", test_pg93_read00004),
        ("test_pg93_read00005", test_pg93_read00005),
        ("test_pg93_read00006", test_pg93_read00006),
        ("test_pg93_read00007", test_pg93_read00007),
        ("test_pg93_read00008", test_pg93_read00008),
        ("test_pg93_read00009", test_pg93_read00009),
        ("test_pg93_read00010", test_pg93_read00010),
        ("test_pg93_read00011", test_pg93_read00011),
        ("test_pg93_read00012", test_pg93_read00012),
        ("test_pg93_read00013", test_pg93_read00013),
        ("test_pg93_read00014", test_pg93_read00014),
    ]

    /// Simple 8-bit integer ramp
    func test_pg93_read00001() {
        
        let url = Bundle.module.url(forResource: "tst0001", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }

        XCTAssertEqual(file.prime.bitpix, .UINT8)
        
        XCTAssertEqual(file.HDUs.count, 0)
        //file.debugDescription
    }
    
    /// Simple 16-bit integer file with 3 axes
    func test_pg93_read00002() {
        
        let url = Bundle.module.url(forResource: "tst0002", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }
         
        XCTAssertEqual(file.prime.bitpix, .INT16)
        
        XCTAssertEqual(file.HDUs.count, 0)
        //file.debugDescription
    }
    
    /// Simple 32-bit integer file
    func test_pg93_read00003() {
        
        let url = Bundle.module.url(forResource: "tst0003", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }
        
        XCTAssertEqual(file.prime.bitpix, .INT32)
        
        XCTAssertEqual(file.HDUs.count, 0)
        //file.debugDescription
    }
    
    /// Simple 32-bit integer file with scaling
    func test_pg93_read00004() {
        
        let url = Bundle.module.url(forResource: "tst0004", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }

        XCTAssertEqual(file.prime.bitpix, .INT32)
        
        XCTAssertEqual(file.HDUs.count, 0)
        //file.debugDescription
    }
    
    /// Simple 32-bit IEEE Floating Point file
    func test_pg93_read00005() {
        
        let url = Bundle.module.url(forResource: "tst0005", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }
        
        XCTAssertEqual(file.prime.bitpix, .FLOAT32)
        
        XCTAssertEqual(file.HDUs.count, 0)
        //file.debugDescription
    }
    
    /// Simple 64-bit IEEE Floating Point file
    func test_pg93_read00006() {
        
        let url = Bundle.module.url(forResource: "tst0006", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }
        
        XCTAssertEqual(file.prime.bitpix, .FLOAT64)
        
        XCTAssertEqual(file.HDUs.count, 0)
        //file.debugDescription
    }
    
    /// Test 32-bit IEEE Fp special values
    func test_pg93_read00007() {
        
        let url = Bundle.module.url(forResource: "tst0007", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }
        
        XCTAssertEqual(file.prime.bitpix, .FLOAT32)
        
        XCTAssertEqual(file.HDUs.count, 0)
        //file.debugDescription
    }
    
    /// Test 64-bit IEEE Fp special values
    func test_pg93_read00008() {
        
        let url = Bundle.module.url(forResource: "tst0008", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }
        
        XCTAssertEqual(file.prime.bitpix, .FLOAT64)
        
        XCTAssertEqual(file.HDUs.count, 0)
        //file.debugDescription
    }
    
    /// TABLE + IMAGE
    func test_pg93_read00009() {
        
        let url = Bundle.module.url(forResource: "tst0009", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }
        
        XCTAssertEqual(file.prime.bitpix, .UINT8)
        
        XCTAssertEqual(file.HDUs.count, 2)
        //file.debugDescription
        
        guard let table = file.HDUs[0] as? TableHDU else {
            XCTFail("Expected table")
            return
        }
        
        XCTAssertEqual(table.bitpix, .UINT8)
        XCTAssertEqual(table.naxis, 2)
        XCTAssertEqual(table.naxis(1), 59)
        XCTAssertEqual(table.naxis(2), 53)
        XCTAssertEqual(table.tfields, 8)
        XCTAssertEqual(table.columns.count,8)
        XCTAssertEqual(table.rows.count,53)
        
        guard let image = file.HDUs[1] as? ImageHDU else {
            XCTFail("Expected table")
            return
        }
        
        XCTAssertEqual(image.bitpix, .INT16)
        XCTAssertEqual(image.naxis, 3)
        XCTAssertEqual(image.naxis(1), 73)
        XCTAssertEqual(image.naxis(2), 31)
        
        XCTAssertEqual(image.dataUnit?.count, 22630)
        
    }
    
    /// BINTABLE + IMAGE
    func test_pg93_read00010() {
        
        let url = Bundle.module.url(forResource: "tst0010", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }
        
        XCTAssertEqual(file.HDUs.count, 2)
        
        guard let bintable = file.HDUs[0] as? BintableHDU else {
            XCTFail("Expected bintable")
            return
        }
        
        XCTAssertEqual(bintable.bitpix, .UINT8)
        XCTAssertEqual(bintable.naxis, 2)
        XCTAssertEqual(bintable.naxis(1), 99)
        XCTAssertEqual(bintable.naxis(2), 11)
        XCTAssertEqual(bintable.tfields, 13)
        XCTAssertEqual(bintable.columns.count, 13)
        XCTAssertEqual(bintable.rows.count, 11)
        
        XCTAssertEqual(bintable.dataUnit?.count, 3820)
        XCTAssertEqual(bintable.heap?.count, 2713)
        
        XCTAssertEqual(bintable.columns[0].TTYPE, "IDENT   ")
        XCTAssertEqual(bintable.columns[0].TFORM, BFORM.A(r: 9))
        XCTAssertEqual(bintable.columns[0][0],BFIELD.A(val: "Ident2001"))
        XCTAssertEqual(bintable.columns[0][1],BFIELD.A(val: "Ident2002"))
        XCTAssertEqual(bintable.columns[0][2],BFIELD.A(val: "Ident2003"))
        XCTAssertEqual(bintable.columns[0][3],BFIELD.A(val: "Ident2004"))
        XCTAssertEqual(bintable.columns[0][4],BFIELD.A(val: "Ident2005"))
        XCTAssertEqual(bintable.columns[0][5],BFIELD.A(val: "Ident\0\0\0\0"))
        XCTAssertEqual(bintable.columns[0][6],BFIELD.A(val: "Ident2007"))
        XCTAssertEqual(bintable.columns[0][7],BFIELD.A(val: "Ident2008"))
        XCTAssertEqual(bintable.columns[0][8],BFIELD.A(val: "Ident2009"))
        XCTAssertEqual(bintable.columns[0][9],BFIELD.A(val: "\0\0\0\0\0\0\0\0\0"))
        XCTAssertEqual(bintable.columns[0][10],BFIELD.A(val: "Ident2011"))
        
        XCTAssertEqual(bintable.columns[1].TTYPE, "FLAGS   ")
        XCTAssertEqual(bintable.columns[1].TFORM, BFORM.X(r: 13))
        XCTAssertEqual(bintable.columns[1][0], BFIELD.X(val: Data([0b11111111,0b11111000])))
        XCTAssertEqual(bintable.columns[1][1], BFIELD.X(val: Data([0b11111111,0b11110000])))
        XCTAssertEqual(bintable.columns[1][2], BFIELD.X(val: Data([0b11111111,0b00001000])))
        XCTAssertEqual(bintable.columns[1][3], BFIELD.X(val: Data([0b11110000,0b11111000])))
        XCTAssertEqual(bintable.columns[1][4], BFIELD.X(val: Data([0b00001111,0b11111000])))
        XCTAssertEqual(bintable.columns[1][5], BFIELD.X(val: Data([0b00000000,0b00000000])))
        XCTAssertEqual(bintable.columns[1][6], BFIELD.X(val: Data([0b00010001,0b00010000])))
        XCTAssertEqual(bintable.columns[1][7], BFIELD.X(val: Data([0b00100010,0b00100000])))
        XCTAssertEqual(bintable.columns[1][8], BFIELD.X(val: Data([0b01000100,0b01000000])))
        XCTAssertEqual(bintable.columns[1][9], BFIELD.X(val: Data([0b10001000,0b10001000])))
        XCTAssertEqual(bintable.columns[1][10], BFIELD.X(val: Data([0b10101011,0b11001000])))
        
        XCTAssertEqual(bintable.columns[2].TTYPE, "COUNTS  ")
        XCTAssertEqual(bintable.columns[2].TFORM, BFORM.B(r: 3))
        XCTAssertEqual(bintable.columns[2][0],BFIELD.B(val: [1,2,3]))
        XCTAssertEqual(bintable.columns[2][1],BFIELD.B(val: [17,18,19]))
        XCTAssertEqual(bintable.columns[2][2],BFIELD.B(val: [237,237,237]))
        XCTAssertEqual(bintable.columns[2][3],BFIELD.B(val: [49,50,51]))
        XCTAssertEqual(bintable.columns[2][4],BFIELD.B(val: [65,237,67]))
        XCTAssertEqual(bintable.columns[2][5],BFIELD.B(val: [81,82,83]))
        XCTAssertEqual(bintable.columns[2][6],BFIELD.B(val: [237,98,99]))
        XCTAssertEqual(bintable.columns[2][7],BFIELD.B(val: [113,114,115]))
        XCTAssertEqual(bintable.columns[2][8],BFIELD.B(val: [129,130,237]))
        XCTAssertEqual(bintable.columns[2][9],BFIELD.B(val: [145,146,147]))
        XCTAssertEqual(bintable.columns[2][10],BFIELD.B(val: [161,162,163]))
        
        XCTAssertEqual(bintable.columns[3].TTYPE, "COOR    ")
        XCTAssertEqual(bintable.columns[3].TFORM, BFORM.D(r: 2))
        //XCTAssertEqual(bintable.columns[3].values, [])
        
        XCTAssertEqual(bintable.columns[4].TTYPE, "FLUX    ")
        XCTAssertEqual(bintable.columns[4].TFORM, BFORM.E(r: 3))
        //XCTAssertEqual(bintable.columns[4].values, [])
        
        XCTAssertEqual(bintable.columns[5].TTYPE, "DUMMY   ")
        XCTAssertEqual(bintable.columns[5].TFORM, BFORM.J(r: 0))
        
        
        
        XCTAssertEqual(bintable.columns[6].TFORM, BFORM.I(r: 1))
        //XCTAssertEqual(bintable.columns[6].values, [])
        
        XCTAssertEqual(bintable.columns[7].TTYPE, "Yes_No  ")
        XCTAssertEqual(bintable.columns[7].TFORM, BFORM.L(r: 2))
        XCTAssertEqual(bintable.columns[7][0], BFIELD.L(val: [true,true]))
        XCTAssertEqual(bintable.columns[7][1], BFIELD.L(val: [false,true]))
        XCTAssertEqual(bintable.columns[7][2], BFIELD.L(val: [true,false]))
        XCTAssertEqual(bintable.columns[7][3], BFIELD.L(val: [false,false]))
        XCTAssertEqual(bintable.columns[7][4], BFIELD.L(val: []))
        XCTAssertEqual(bintable.columns[7][5], BFIELD.L(val: [true,true]))
        XCTAssertEqual(bintable.columns[7][6], BFIELD.L(val: [false]))
        XCTAssertEqual(bintable.columns[7][7], BFIELD.L(val: [false]))
        XCTAssertEqual(bintable.columns[7][8], BFIELD.L(val: [false,false]))
        XCTAssertEqual(bintable.columns[7][9], BFIELD.L(val: [true]))
        XCTAssertEqual(bintable.columns[7][10], BFIELD.L(val: [true]))
        
        XCTAssertEqual(bintable.columns[8].TTYPE, "Index   ")
        XCTAssertEqual(bintable.columns[8].TFORM, BFORM.J(r: 3))
        
        XCTAssertEqual(bintable.columns[9].TTYPE, "Array   ")
        XCTAssertEqual(bintable.columns[9].TFORM, BFORM.PI(r: 13))
        XCTAssertEqual(bintable.columns[9][0], BFIELD.PI(val: []))
        XCTAssertEqual(bintable.columns[9][1], BFIELD.PI(val: [1792, 2048, 2304, 2560, 2816, 3072, 3328, 3584, 3841, 1, 257, 513, 769, 1025, 1281, 1537, 1793, 2049]))
        XCTAssertEqual(bintable.columns[9][2], BFIELD.PI(val: [256, 512, 768, 1024, 1280, 1536, 1792, 2048, 2304, 2560, 2816, 3072, 3328, 3584, 3841, 1, 257, 513, 769, 1025, 1281, 1537, 1793, 2049, 2305, 2561, 2817, 3073, 3329, 3585, 3842, 2, 258, 514, 770, 1026, 1282, 1538, 1794, 2050, 2306, 2562, 2818, 3074, 3330, 3586, 3843, 3, 259]))
        XCTAssertEqual(bintable.columns[9][3], BFIELD.PI(val: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 768, 769, 770, 771, 772, 773, 774, 775, 776]))
        XCTAssertEqual(bintable.columns[9][4], BFIELD.PI(val: [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 256, 257, 258, 259, 260]))
        XCTAssertEqual(bintable.columns[9][5], BFIELD.PI(val: [768, 1024, 1280, 1536]))
        XCTAssertEqual(bintable.columns[9][6], BFIELD.PI(val: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 256, 257, 258, 259]))
        XCTAssertEqual(bintable.columns[9][7], BFIELD.PI(val: [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 768, 769, 770, 771, 772, 773, 774, 775, 776, 777, 778, 779, 780, 781, 782, 783, 1024, 1025]))
        XCTAssertEqual(bintable.columns[9][8], BFIELD.PI(val: [1280, 1536, 1792, 2048, 2304, 2560, 2816, 3072, 3328, 3584, 3841, 1, 257, 513, 769, 1025, 1281, 1537, 1793, 2049, 2305, 2561, 2817, 3073, 3329, 3585, 3842, 2, 258, 514, 770, 1026, 1282, 1538, 1794, 2050, 2306, 2562, 2818, 3074, 3330, 3586, 3843, 3, 259, 515, 771, 1027, 1283, 1539, 1795, 2051, 2307, 2563, 2819, 3075, 3331, 3587, 3844, 4, 260, 516, 772, 1028, 1284, 1540, 1796, 2052, 2308, 2564, 2820, 3076, 3332, 3588, 3845, 5, 261, 517, 773, 1029, 1285, 1541, 1797, 2053, 2309, 2565, 2821, 3077, 3333, 3589, 3846, 6, 262, 518, 774, 1030, 1286, 1542, 1798, 2054, 2310, 2566, 2822, 3078, 3334, 3590, 3847, 7, 263, 519, 775, 1031, 1287, 1543, 1799, 2055, 2311, 2567, 2823, 3079, 3335, 3591, 3848, 8, 264, 520, 776, 1032, 1288, 1544, 1800, 2056, 2312, 2568, 2824, 3080, 3336, 3592, 3849, 9, 265, 521, 777, 1033]))
        XCTAssertEqual(bintable.columns[9][9], BFIELD.PI(val: [1792, 2048, 2304, 2560, 2816, 3072, 3328, 3584, 3841, 1, 257, 513, 769, 1025, 1281, 1537, 1793, 2049, 2305, 2561, 2817, 3073, 3329, 3585, 3842, 2, 258, 514, 770, 1026, 1282, 1538, 1794, 2050, 2306, 2562, 2818, 3074, 3330, 3586, 3843, 3, 259, 515, 771, 1027, 1283, 1539, 1795, 2051, 2307, 2563, 2819, 3075, 3331, 3587, 3844, 4, 260, 516, 772, 1028, 1284, 1540, 1796, 2052, 2308, 2564, 2820, 3076, 3332, 3588, 3845, 5, 261, 517, 773, 1029, 1285, 1541, 1797, 2053, 2309, 2565, 2821, 3077, 3333, 3589, 3846, 6, 262, 518, 774]))
        XCTAssertEqual(bintable.columns[9][10], BFIELD.PI(val: [1024, 1280, 1536, 1792, 2048, 2304, 2560, 2816, 3072, 3328, 3584, 3841, 1, 257, 513, 769, 1025, 1281, 1537, 1793, 2049, 2305, 2561, 2817, 3073, 3329, 3585, 3842, 2, 258, 514, 770, 1026, 1282, 1538, 1794, 2050, 2306, 2562, 2818, 3074, 3330, 3586, 3843, 3, 259, 515, 771, 1027, 1283, 1539, 1795, 2051, 2307, 2563, 2819, 3075, 3331, 3587, 3844, 4, 260, 516, 772, 1028, 1284, 1540, 1796, 2052, 2308, 2564, 2820, 3076, 3332, 3588, 3845, 5, 261, 517, 773, 1029, 1285, 1541, 1797, 2053, 2309, 2565, 2821, 3077, 3333, 3589, 3846, 6, 262, 518, 774, 1030, 1286, 1542, 1798, 2054, 2310, 2566, 2822, 3078, 3334, 3590, 3847, 7, 263, 519, 775, 1031, 1287, 1543, 1799, 2055, 2311, 2567, 2823, 3079, 3335]))
        
        XCTAssertEqual(bintable.columns[10].TTYPE, "Complex ")
        XCTAssertEqual(bintable.columns[10].TFORM, BFORM.C(r: 2))
        
        XCTAssertEqual(bintable.columns[11].TTYPE, "Cplx_64 ")
        XCTAssertEqual(bintable.columns[11].TFORM, BFORM.M(r: 1))
        
        
        XCTAssertEqual(bintable.columns[12].TTYPE, "NOTE    ")
        XCTAssertEqual(bintable.columns[12].TFORM, BFORM.B(r: 1))
        XCTAssertEqual(bintable.columns[12][0], BFIELD.B(val: [1]))
        XCTAssertEqual(bintable.columns[12][1], BFIELD.B(val: [2]))
        XCTAssertEqual(bintable.columns[12][2], BFIELD.B(val: [80]))
        XCTAssertEqual(bintable.columns[12][3], BFIELD.B(val: [0]))
        XCTAssertEqual(bintable.columns[12][4], BFIELD.B(val: [16]))
        XCTAssertEqual(bintable.columns[12][5], BFIELD.B(val: [69]))
        XCTAssertEqual(bintable.columns[12][6], BFIELD.B(val: [10]))
        XCTAssertEqual(bintable.columns[12][7], BFIELD.B(val: [64]))
        XCTAssertEqual(bintable.columns[12][8], BFIELD.B(val: [0]))
        XCTAssertEqual(bintable.columns[12][9], BFIELD.B(val: [255]))
        XCTAssertEqual(bintable.columns[12][10], BFIELD.B(val: [5]))

        guard let image = file.HDUs[1] as? ImageHDU else {
            XCTFail("Expected bintable")
            return
        }
        
        XCTAssertEqual(image.bitpix, .INT16)
        XCTAssertEqual(image.naxis, 3)
        XCTAssertEqual(image.naxis(1), 73)
        XCTAssertEqual(image.naxis(2), 31)
        
        XCTAssertEqual(image.dataUnit?.count, 22630)

    }
    
    /// IMAGE + TABLE
    func test_pg93_read00011() {
        
        let url = Bundle.module.url(forResource: "tst0011", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }
        
        XCTAssertEqual(file.prime.bitpix, .UINT8)
        
        XCTAssertEqual(file.HDUs.count, 2)
        //file.debugDescription
    }
    
    /// 32+BNTBL+UNKNWN+IMGE+TBLE
    func test_pg93_read00012() {
        
        let url = Bundle.module.url(forResource: "tst0012", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }
        
        XCTAssertEqual(file.HDUs.count, 4)
        XCTAssertTrue(file.HDUs[0] is BintableHDU)
        // XCTAssertTrue(file.HDUs[1] is AnyHDU) // Always true
        XCTAssertTrue(file.HDUs[2] is ImageHDU)
        XCTAssertTrue(file.HDUs[3] is TableHDU)
        //file.debugDescription
    }
    
    /// Image with ESO HIERARCH keywords
    func test_pg93_read00013() {
        
        let url = Bundle.module.url(forResource: "tst0013", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }
        
        XCTAssertEqual(file.prime.bitpix, .FLOAT32)
        
        XCTAssertEqual(file.HDUs.count, 0)
        //file.debugDescription
    }
    
    /// Sample of ESO-MIDAS BINTABLE
    func test_pg93_read00014() {
        
        let url = Bundle.module.url(forResource: "tst0014", withExtension: "fits")
        guard let file = try! FitsFile.read(contentsOf: url!) else {
            XCTFail("FitsFile must not be null")
            return
        }
        
        XCTAssertEqual(file.prime.bitpix, .UINT8)
        
        XCTAssertEqual(file.HDUs.count, 1)
        //file.debugDescription
    }
}
