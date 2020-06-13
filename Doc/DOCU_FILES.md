
Quicklinks : [Introduction](DOCU_INTRO.md) | [Files](DOCU_FILES.md) | [HDUs](DOCU_HDUS.md) | [Bytes](DOCU_BYTES.md) | [Tables](DOCU_TABLES.md)

# Working with Files

## Reading FITS Files

FITS files can be conveniently read from an file `URL`. Since reading large files might take a while, the parsed file is provied via the `onCompletion` callback. In order to treat error gently, errors during parsing are also provided via an `onError` callback rather than the `throw` clause. This allows to read FITS files which might comply perfeclty with the standard.

```swift
let file = try FitsFile.read(from: url, onError: { error in
    print(error)
}, onCompletion: { file in
    // handle the file here 
})
```

Alternatively, the file can be read straightforward from a raw `Data` bytestream
```swift

let file = try FitsFile.read(from: &data)
```

## Writing FITS Files

[FITS files](../Sources/FITS/FitsFile.swift) can be created and written to an `URL` very similar to reading them:
```swift

file.write(to: url, onError: { error in
    print(error)
}) {
    // file written
}
```

Alternatively, the file can be written straigthforward into a raw `Data` bytestream
```swift

var data = Data()
file.write(to: &data)
```

Note that FITS files are read and wirtten along the document tree in sequential order:
* `FITSFile`
    * `PrimaryHDU`
        * `HeaderBlock` 
            * `HDUKeyworld`
            * `HDUValue`
            * `Comment`
        * `DataUnit`
    * `HDU1`
    * ...

Each of these elements can be read or written individually via the [FITSReader](../Sources/FITS/IO/FITSReader.swift) and [FITSWriter](../Sources/FITS/IO/FITSWriter.swift) interfaces
