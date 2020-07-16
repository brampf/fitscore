
import XCTest
@testable import FITS


final class FitsTests: XCTestCase {

    static var allTests = [
        ("testReadFile", testReadFile),
        ("testReadImage", testReadImage),
        ("testReadTable", testReadTable),
        ("testReadBintable", testReadBintable)
        
    ]
    
    func testReadFile() {
        
        guard var data = Data(base64Encoded: SiriLSample) else {
            XCTFail("No Data")
            return
        }
        
        let fits = try! FitsFile.read(from: &data)

        XCTAssertNotNil(fits)
        
        XCTAssertEqual(fits.prime.isSimple, true)
        XCTAssertEqual(fits.prime.bitpix, BITPIX.UINT8)
        XCTAssertEqual(fits.prime.naxis, 3)
        XCTAssertEqual(fits.prime.naxis(1), 480)
        XCTAssertEqual(fits.prime.naxis(2), 360)
        XCTAssertEqual(fits.prime.naxis(3), 3)
    }
    
    func testReadImage() {
        
        guard var data = Data(base64Encoded: Image) else {
            return XCTFail("Unable to read sample")
        }
        
        guard let hdu = try? TableHDU(with: &data) else {
            XCTFail("HDU must not be null")
            return
        }
        
        for header in hdu.headerUnit {
            print(header.description)
            //print(header.raw)
        }
        
        XCTAssertEqual(hdu.modified, false)
        XCTAssertEqual(hdu.bitpix, BITPIX.INT16)
        XCTAssertEqual(hdu.naxis,2)
        XCTAssertEqual(hdu.naxis(1), 512)
        XCTAssertEqual(hdu.naxis(1), 512)
        XCTAssertEqual(hdu.dataSize, 512*512*2)
        XCTAssertEqual(hdu.dataUnit?.count, 512*512*2)
        
    }
    
    func testReadTable() {
        
        guard var data = Data(base64Encoded: Table) else {
            return XCTFail("Unable to read sample")
        }
        
        guard let hdu = try? TableHDU(with: &data) else {
            XCTFail("HDU must not be null")
            return
        }
        
        for header in hdu.headerUnit {
            print(header.description)
        }
        
        XCTAssertEqual(hdu.modified, false)
        XCTAssertEqual(hdu.bitpix, BITPIX.UINT8)
        XCTAssertEqual(hdu.naxis,2)
        XCTAssertEqual(hdu.naxis(1), 99)
        XCTAssertEqual(hdu.naxis(2), 7)
        XCTAssertEqual(hdu.lookup(HDUKeyword.TFIELDS), 6)
        XCTAssertEqual(hdu.columns.count, 6)
        XCTAssertEqual(hdu.columns[0].values.count, 7)
        XCTAssertEqual(hdu.columns[1].values.count, 7)
        XCTAssertEqual(hdu.columns[2].values.count, 7)
        XCTAssertEqual(hdu.columns[3].values.count, 7)
        XCTAssertEqual(hdu.columns[4].values.count, 7)
        XCTAssertEqual(hdu.columns[5].values.count, 7)
        
        XCTAssertEqual(hdu.columns[0].TFORM, TFORM.E(w: 15, d: 7))
        XCTAssertEqual(hdu.columns[1].TFORM, TFORM.E(w: 15, d: 7))
        XCTAssertEqual(hdu.columns[2].TFORM, TFORM.E(w: 15, d: 7))
        XCTAssertEqual(hdu.columns[3].TFORM, TFORM.E(w: 15, d: 7))
        XCTAssertEqual(hdu.columns[4].TFORM, TFORM.D(w: 25, d: 17))
        XCTAssertEqual(hdu.columns[5].TFORM, TFORM.A(w: 8))
        
        XCTAssertEqual(hdu.columns[0].TDISP, TDISP.G(w: 15, d: 7, e: nil))
        XCTAssertEqual(hdu.columns[1].TDISP, TDISP.G(w: 15, d: 7, e: nil))
        XCTAssertEqual(hdu.columns[2].TDISP, TDISP.G(w: 15, d: 7, e: nil))
        XCTAssertEqual(hdu.columns[3].TDISP, TDISP.G(w: 15, d: 7, e: nil))
        XCTAssertEqual(hdu.columns[4].TDISP, TDISP.G(w: 25, d: 16, e: nil))
        XCTAssertEqual(hdu.columns[5].TDISP, TDISP.A(w: 8))
        
        XCTAssertEqual(hdu.columns[0].values[0], TFIELD.E(val: 0.0000000E+00))
        XCTAssertEqual(hdu.columns[0].values[1], TFIELD.E(val: 0.0000000E+00))
        XCTAssertEqual(hdu.columns[0].values[2], TFIELD.E(val: 0.0000000E+00))
        XCTAssertEqual(hdu.columns[0].values[3], TFIELD.E(val: 0.0000000E+00))
        XCTAssertEqual(hdu.columns[0].values[4], TFIELD.E(val: 0.0000000E+00))
        XCTAssertEqual(hdu.columns[0].values[5], TFIELD.E(val: 0.0000000E+00))
        
        XCTAssertEqual(hdu.columns[1].values[0], TFIELD.E(val: 4.7900000E+02))
        XCTAssertEqual(hdu.columns[1].values[1], TFIELD.E(val: 4.7900000E+02))
        XCTAssertEqual(hdu.columns[1].values[2], TFIELD.E(val: 4.7900000E+02))
        XCTAssertEqual(hdu.columns[1].values[3], TFIELD.E(val: 4.7900000E+02))
        XCTAssertEqual(hdu.columns[1].values[4], TFIELD.E(val: 3.3895200E+05))
        XCTAssertEqual(hdu.columns[1].values[5], TFIELD.E(val: 8.3172100E+05))
        
        XCTAssertEqual(hdu.columns[4].values[0], TFIELD.D(val: 4.99471371062592860E+08))
        XCTAssertEqual(hdu.columns[4].values[1], TFIELD.D(val: 4.99471371062592860E+08))
        XCTAssertEqual(hdu.columns[4].values[2], TFIELD.D(val: 4.99471371062592860E+08))
        XCTAssertEqual(hdu.columns[4].values[3], TFIELD.D(val: 4.99471371062592860E+08))
        XCTAssertEqual(hdu.columns[4].values[4], TFIELD.D(val: 4.99471371062592860E+08))
        XCTAssertEqual(hdu.columns[4].values[5], TFIELD.D(val: 4.99471371062592860E+08))
        
        XCTAssertEqual(hdu.columns[5].values[0], TFIELD.A(val: "SECONDS"))
        XCTAssertEqual(hdu.columns[5].values[1], TFIELD.A(val: "SECONDS"))
        XCTAssertEqual(hdu.columns[5].values[2], TFIELD.A(val: "SECONDS"))
        XCTAssertEqual(hdu.columns[5].values[3], TFIELD.A(val: "SECONDS"))
        XCTAssertEqual(hdu.columns[5].values[4], TFIELD.A(val: "SECONDS"))
        XCTAssertEqual(hdu.columns[5].values[5], TFIELD.A(val: "SECONDS"))
    }
    
    func testReadBintable() {
        
        guard var data = Data(base64Encoded: Bintable) else {
            return XCTFail("Unable to read sample")
        }
        
        guard let hdu = try? BintableHDU(with: &data) else {
            XCTFail("HDU must not be null")
            return
        }
        
        for header in hdu.headerUnit {
            print(header.description)
            //print(header.raw)
        }
        
        XCTAssertEqual(hdu.modified, false)
        XCTAssertEqual(hdu.bitpix, BITPIX.UINT8)
        XCTAssertEqual(hdu.naxis,2)
        XCTAssertEqual(hdu.naxis(1), 11535)
        XCTAssertEqual(hdu.naxis(2), 1)
        XCTAssertEqual(hdu.lookup(HDUKeyword.TFIELDS), 9)
        
        XCTAssertEqual(hdu.columns[0].values.count, 1)
        XCTAssertEqual(hdu.columns[1].values.count, 1)
        XCTAssertEqual(hdu.columns[2].values.count, 1)
        XCTAssertEqual(hdu.columns[3].values.count, 1)
        XCTAssertEqual(hdu.columns[4].values.count, 1)
        XCTAssertEqual(hdu.columns[5].values.count, 1)
        XCTAssertEqual(hdu.columns[6].values.count, 1)
        XCTAssertEqual(hdu.columns[7].values.count, 1)
        XCTAssertEqual(hdu.columns[8].values.count, 1)
        
        XCTAssertEqual(hdu.columns[0].TFORM, BFORM.A(r: 5))
        XCTAssertEqual(hdu.columns[1].TFORM, BFORM.I(r: 1))
        XCTAssertEqual(hdu.columns[2].TFORM, BFORM.E(r: 1))
        XCTAssertEqual(hdu.columns[3].TFORM, BFORM.E(r: 1))
        XCTAssertEqual(hdu.columns[4].TFORM, BFORM.E(r: 640))
        XCTAssertEqual(hdu.columns[5].TFORM, BFORM.E(r: 640))
        XCTAssertEqual(hdu.columns[6].TFORM, BFORM.E(r: 640))
        XCTAssertEqual(hdu.columns[7].TFORM, BFORM.I(r: 640))
        XCTAssertEqual(hdu.columns[8].TFORM, BFORM.E(r: 640))
        
        XCTAssertEqual(hdu.columns[0].values[0], BFIELD.A(val: "LARGE"))
        XCTAssertEqual(hdu.columns[1].values[0], BFIELD.I(val: [640]))
        XCTAssertEqual(hdu.columns[2].values[0], BFIELD.E(val: [1750.00]))
        XCTAssertEqual(hdu.columns[3].values[0], BFIELD.E(val: [2.6627994]))
        XCTAssertEqual(hdu.columns[4].values[0], BFIELD.E(val: [8.161818, -13.177735, -28.264069, -12.052042, 1.0414951, -5.8204756, -2.0811617, 33.30005, 3.580076, 2.0902393, -47.130417, -14.539634, 15.496194, -5.824673, 129.90448, -235.17075, -454.02747, -27.941708, -67.742134, -34.18592, -10.889748, -15.63138, -10.334335, 4.848886, 17.201244, 17.636543, -13.4157095, -0.37549096, -22.466593, -20.265451, -11.969815, 10.712841, 14.441741, 39.126377, 19.785826, 20.084679, -1.2381921, -13.746267, 0.997644, 28.772425, 30.9864, 15.492429, -3.5295658, 12.333336, 13.781543, 7.903731, 26.776852, 23.518631, 3.5756657, 21.367365, 53.995956, 42.44511, 29.25159, 27.523499, 35.35618, 41.78909, 48.631954, 42.458416, 90.14014, 70.65725, 86.65458, 96.66452, 87.834946, 83.90991, 82.45051, 86.50219, 92.99004, 63.87008, 79.429794, 48.708622, 62.998077, 74.99124, 62.076992, 90.40003, 68.27515, 57.98665, 66.61418, 52.88797, 49.62958, 79.19941, 50.655422, 66.47989, 70.28084, 91.694435, 86.16674, 69.0561, 31.942457, 59.747334, 76.69065, 74.86283, 94.57843, 46.047897, 62.14562, 54.786625, 66.41071, 57.153687, 60.17477, 78.413734, 82.94957, 53.23233, 58.620956, 93.02386, 73.04955, 93.7263, 73.26818, 52.236088, 70.27695, 86.278915, 69.8493, 94.79121, 117.17559, 79.37165, 99.48883, 77.62337, 67.70886, 51.611057, 80.731026, 78.768745, 94.75337, 75.96027, 61.1713, 81.83558, 103.61804, 93.06936, 84.50605, 73.345985, 100.70813, 116.64577, 99.79651, 74.89557, 87.75178, 85.68254, 93.38189, 104.67914, 79.84134, 97.616264, 97.04441, 82.89092, 72.95476, 77.04169, 70.88936, 69.96902, 75.73241, 65.64043, 83.962494, 59.83563, 76.65881, 93.09833, 102.629974, 96.05824, 87.442665, 57.656513, 84.9399, 118.35816, 77.17027, 105.08509, 102.80298, 49.074654, 74.25835, 68.850075, 62.11919, 82.03935, 101.86514, 101.39971, 74.48243, 95.17175, 85.26363, 86.295, 75.299576, 64.58884, 69.28555, 63.674377, 75.773834, 74.46025, 70.78011, 98.84858, 92.18551, 54.753162, 91.45556, 85.79174, 79.5212, 73.9628, 88.72782, 81.97334, 84.45569, 87.42857, 105.51526, 76.046875, 68.28649, 105.33226, 79.161064, 82.70606, 57.306488, 92.0521, 80.31542, 80.26553, 101.24441, 88.56616, 60.503353, 82.43721, 95.46882, 92.71461, 108.88679, 124.41646, 78.97197, 94.86898, 121.79149, 120.618866, 88.93044, 109.48338, 114.442535, 91.903275, 85.2007, 99.93322, 98.7152, 104.958015, 106.21681, 118.22311, 120.43374, 153.26355, 177.87724, 171.47037, 150.33844, 147.31682, 141.97159, 143.17905, 128.07646, 86.05937, 130.57544, 127.94845, 165.59259, 130.941, 115.498146, 131.5957, 152.04489, 138.42079, 157.35533, 137.25203, 103.932755, 130.09175, 119.66778, 141.71077, 140.15569, 163.39722, 165.48283, 186.39722, 155.70435, 180.74847, 160.36699, 150.4871, 143.71587, 154.03766, 166.4496, 197.34671, 161.01474, 198.3331, 226.89346, 192.28337, 194.50273, 178.84386, 210.18463, 210.88287, 233.92659, 184.7112, 234.38263, 241.0426, 212.05547, 184.73001, 243.11588, 226.00032, 222.92392, 199.25714, 240.54489, 232.42482, 259.8064, 241.25575, 223.07523, 218.4752, 234.16373, 235.51556, 216.42578, 213.538, 236.61899, 236.32225, 240.84274, 247.88043, 277.78137, 253.99156, 276.48886, 279.14294, 279.25165, 243.50691, 270.44287, 283.60715, 270.424, 260.20972, 317.25885, 268.00623, 275.47006, 254.31775, 246.97595, 270.2363, 246.43848, 265.3958, 271.60507, 255.37778, 274.65457, 329.3433, 273.64795, 312.50388, 302.94678, 249.43791, 277.62057, 278.67596, 298.5003, 236.4946, 212.80476, 315.13843, 270.09586, 252.11902, 244.39514, 273.4592, 265.7445, 296.25293, 261.184, 271.12112, 309.41403, 292.27747, 360.03363, 320.45282, 354.4716, 293.66565, 309.70203, 375.01437, 347.06497, 370.6031, 328.76663, 331.93356, 367.89282, 359.14465, 354.15918, 360.80698, 333.07254, 316.4861, 379.74905, 349.22305, 305.3511, 331.79144, 349.70474, 307.8866, 370.6984, 298.5795, 317.38263, 423.67426, 377.52908, 395.77338, 355.4896, 356.75256, 328.64975, 350.64688, 360.29105, 361.72012, 324.56516, 325.43976, 361.39722, 390.0881, 381.17676, 339.8202, 385.28378, 363.0092, 384.91495, 384.92426, 373.80423, 408.72064, 401.04953, 389.13303, 383.2363, 410.71445, 372.02542, 440.96475, 448.77264, 463.36005, 428.4809, 435.2628, 469.4709, 429.5242, 438.1216, 486.66495, 475.7839, 496.81534, 499.8111, 466.66714, 503.50967, 584.3619, 454.3248, 481.753, 456.67682, 522.18036, 545.04236, 656.7655, 648.073, 714.645, 615.9469, 561.3437, 549.5403, 572.33264, 574.4408, 469.25928, 455.1067, 451.71494, 485.15475, 463.78168, 413.86606, 438.329, 439.50912, 378.8468, 353.3812, 393.59735, 353.93173, 382.2592, 383.60953, 397.62573, 395.75998, 406.01465, 385.2284, 370.38382, 437.47467, 387.0455, 415.64795, 416.2742, 422.60043, 413.49493, 404.80505, 419.73123, 404.1235, 401.12225, 410.12537, 422.12534, 387.70728, 417.56375, 424.48114, 427.7365, 421.32495, 409.64395, 408.91302, 390.2063, 413.47897, 379.8499, 380.96243, 384.17734, 359.39853, 348.56598, 378.44046, 378.42325, 384.2391, 401.7058, 376.98578, 355.70627, 342.3199, 310.84738, 306.58002, 317.97696, 344.945, 359.66486, 337.86087, 313.48114, 323.85297, 330.00595, 338.5156, 327.5169, 327.53482, 316.08984, 277.69516, 283.5912, 301.06204, 287.90045, 276.4833, 309.62534, 298.47556, 268.43832, 265.98944, 302.66586, 279.18707, 260.92816, 288.48474, 272.87717, 283.22232, 290.877, 288.90088, 268.21127, 210.22746, 234.41493, 197.78145, 201.68208, 242.57553, 216.94827, 209.29858, 230.07988, 227.8407, 209.0525, 223.91005, 236.66978, 235.44313, 203.21541, 182.4269, 178.65839, 165.36472, 174.25974, 170.80554, 165.2356, 175.371, 179.1558, 181.07423, 185.15086, 168.7237, 158.80502, 164.35046, 178.50343, 181.92883, 171.88443, 163.51457, 152.75215, 158.02621, 160.22244, 161.65219, 151.16544, 150.15857, 126.67678, 123.151085, 113.83163, 115.7928, 121.91003, 123.45511, 117.40886, 102.98269, 112.51712, 132.56122, 109.35576, 105.83141, 110.08298, 107.5361, 110.5437, 101.09183, 99.90269, 102.44149, 95.012764, 77.288536, 70.823425, 78.6392, 81.06909, 75.52399, 91.04711, 85.16836, 81.572105, 82.06747, 85.61653, 82.664314, 84.710205, 84.96382, 82.7193, 70.74181, 66.67127, 63.925793, 63.843388, 65.38039, 78.03134, 83.12191, 72.035866, 69.974434, 71.7872, 67.82981, 71.55758, 66.95589, 66.6285, 67.46901, 68.93909, 62.840145, 65.03925, 65.2258, 72.07583, 65.177444, 68.085495, 72.69405, 70.44382, 66.96671, 58.695393, 70.7351, 67.1208, 57.7078, 53.877075, 56.506905, 49.960934, 50.157906, 48.295567, 53.33135, 54.99561, 57.749233, 56.630085, 48.504173, 52.269047, 54.144627, 56.11609, 65.854195, 61.026466, 57.370537, 56.949196, 50.75398, 50.0943, 41.49149, 39.010754, 31.36594, 25.413906, 30.798382, 31.138132, 28.114847, 32.660652, 23.042906, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]))
        XCTAssertEqual(hdu.columns[7].values[0], BFIELD.I(val: [-2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -4096, -4096, -4096, -4096, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -514, -1794, -1794, -1794, -18178, -16386, -16386, -16386, -16386, -16386, -16386, -16386, -16386, -16386, -16386, -16386, -16386, -16386, -16386, -16386, -16386, -16386, -16386]))
    }

    func testReadGroups() {
        
        guard var data = Data(base64Encoded: DDTSUVDATA) else {
            return XCTFail("Unable to read sample")
        }
        
        
        let file = try! FitsFile.read(from: &data)
        
        XCTAssertEqual(file.prime.bitpix, BITPIX.FLOAT32)
        XCTAssertEqual(file.prime.gcount, 7956)
        XCTAssertEqual(file.prime.pcount, 6)
        
        let group = Group(file.prime)
        for groupIndex in 0..<(file.prime.gcount ?? 1){
            let val : [FITSByte_8] = group[groupIndex]
            
            print(val)
        }
        
        
        /*
        guard let hdu = try? BintableHDU(with: &data) else {
            XCTFail("HDU must not be null")
            return
        }
        
        for header in hdu.headerUnit {
            print(header.description)
            //print(header.raw)
        }
        
        XCTAssertEqual(hdu.modified, false)
        XCTAssertEqual(hdu.bitpix, BITPIX.UINT8)
        XCTAssertEqual(hdu.naxis,2)
        XCTAssertEqual(hdu.naxis(1), 11535)
        XCTAssertEqual(hdu.naxis(2), 1)
        XCTAssertEqual(hdu.lookup(HDUKeyword.TFIELDS), 9)
 */
        
    }
}
