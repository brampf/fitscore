
Quicklinks : [Introduction](DOCU_INTRO.md) | [Files](DOCU_FILES.md) | [HDUs](DOCU_HDUS.md) | [Bytes](DOCU_BYTES.md) | [Tables](DOCU_TABLES.md)

# Tables

FITSCore provides support for both, the [Table](Sources/FITS/HDU/TableHDU.swift) and the [Bintable](Sources/FITS/HDU/BinableHDU.swift) extensions. This includes low level access to the raw data structures as well as a high level API to create & modify tables.

## Low Level routines

Reading TableHDUs takes place as follows: 
1. Read the header blocks until `END` is reached & move to data unit
2. The unmodified data unit in `dataUnit` 
3. Parse the `Table` from the dataUnit based on the information provided in the header

If the file conforms to the standard, this will work perfectly, and the table can be accessed and modified via the high level routines. But in case the file is misaligned or header information is wrong / missing, this approach allows for corrections inside the open file. Headers can be modified via `hdu.header(_ keyword: HDUKeyword, value: Value, comment: String?)` setter or direcly via the properties like `tfields` on the HDU itslef. Once the headers correct headers have been set, the table strucutre can be reinitilialized via '`hdu.readTable()`. The content of the `Table` data structure can be plotted with a call to `hdu.plot(data: inout Data)`.

Let's assume we have table data in which the `TFIELDS` keyword is missing
```swift

var tableData = Data()
// raw table data
let hdu = try! TableHDU(with: &tableData)
hdu.columns.count // 0

let check1 = hdu.modified // false

hdu.tfields = 99

let check2 = hdu.modified // true

hdu.readTable()
hdu.columns.count // 99

```

**Note** In case of  malformatted files, the raw string of  a  header  can  be  accessed via `block.raw`. Sometimes this helps in situations  in which the parser is not able to read the proper value.


## High Level routines

In order to create, read & modify tables, FITSCore offers convenience routines through the `Table` data structure. Assuimg the file can be read correctly, the table content is available through the `hdu.columns` and `hdu.rows` accessors. Values are pared to `TFIELD` value types (see below)

Creating a new table is real easy. Just add additional columns and set the values to whatever you want
```swift

let hdu = TableHDU()
let _ = hdu.addColumn(TFORM: TFORM.I(w: 5), TDISP: TDISP.I(w: 5, m: 3), TTYPE: "Numbers", TFIELD.I(val: 3),TFIELD.I(val: 333),TFIELD.I(val: 3))
let _ = hdu.addColumn(TFORM: TFORM.A(w: 12), TDISP: TDISP.A(w: 10),  TTYPE: "Text", TFIELD.A(val: "Hello"),TFIELD.A(val: "World"),TFIELD.A(val: "AGAIN"))
let _ = hdu.addColumn(TFORM: TFORM.E(w: 20, d: 5), TDISP: TDISP.E(w: 30, d: 5, e: nil), TTYPE: "Exponentials", TFIELD.E(val: 20392.232234),TFIELD.E(val: 3.93933E+03),TFIELD.E(val: 9393.2232342342342))

```

This table can now be  modified  by  accessing the  fields by their index either by row or by column: 
```swift

hdu.columns[0][1] // 333

hdu.rows[1][2] // 3.93933E+03 

```


In order to write, we just  have to append this hdu to a FITSFile and write that to an url
```swift

let prime = PrimaryHDU()
prime.hasExtensions = true

let file = FitsFile.init(prime: prime)
file.HDUs.append(hdu)

file.write(to: url) {
    // done!
}

```

## Data Types

In order to work with the table strucutres as natural as possible, FITSCore offers native types for the `TFROM`, `TDISP` and `TFIELD` data types. These provide routines for plotting values according to the stadnard via the `TFORM` data layout or the `TDISP` data display definitions. 

All value of the same type can be printed to stdout with the following loop
```swift

hdu.columns.forEach { col in
    print(col.TTYPE ?? "N/A")
    print(String(repeating: "-", count: col.TDISP?.length ?? col.TFORM?.length ?? 0))
    col.values.forEach { field in
        print(field.format(col.TDISP) ?? "N/A")
    }

}

```

The same applied for all values of a row, we just have to know the index of the col to fetch the formatting information:
```swift

hdu.rows.forEach { row in
    var  out = ""
    for col in 0..<row.values.count{
        out.append(row.values[col].format(row.TDISP(col)) ?? "N/A")
    }
    print(out)
}

```

### Table

* [TFIELD.swift](../Sources/FITS/TABLE/TFIELD.swift)
* [TFORM.swift](../Sources/FITS/TABLE/TFORM.swift)
* [TDISP.swift](../Sources/FITS/TABLE/TDISP.swift)

### BinTables

* [BFIELD.swift](../Sources/FITS/BINTABLE/BFIELD.swift)
* [BFORM.swift](../Sources/FITS/BINTABLE/BFORM.swift)
* [BDISP.swift](../Sources/FITS/BINTABLE/BDISP.swift)
