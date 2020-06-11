
# Introduction

## About FITS

The FITS (Flexible Image Transport System) file format is commonly used to store scientific data, particulary in astronomy. It has been around for the past 50 years and been the format of choice from [Hubble Space Telescope](https://www.spacetelescope.org/projects/fits_liberator/datasets_archives/) to the [Vatican Library](https://www.vaticanlibrary.va/home.php?pag=digitfaq&ling=eng&BC=11)

The FITS file Format is very well documented by NASA. There is a [quick introduction](https://fits.gsfc.nasa.gov/fits_primer.html) as well as a well [comprehensive Spec](http://archive.stsci.edu/fits/users_guide/). I strongly recommend reading those. This library was build upon the the Version 4.0 of the FITS Standard as described in the [FITS Standard Document](https://fits.gsfc.nasa.gov/fits_standard.html).

Code comments for various data types such as [BITPIX](Sources/FITS/BITPIX.swift) usually cite the standard document mentioned above to describe the data structures and the values they might contain.

## About this library

There are several great libraries to read & write FITS files in across multiple platforms and languages. But none of those was native on Apple platforms or particulary easy to (cross-) compile. Therefore it seemed convenient to write a native library in [Swift](https://swift.org). Since Swift and its [Packet Manager](https://swift.org/package-manager/) are both platform independent and are maintained for Linux as well, the code was seperated in three packages: 

### FITSCore
This package contains the platform independed code base to read / write FITS files which compiles and runs on macOS / macCatalina, iOS / iPadOS & Linux

### FITSKit
This package contains the apple specific code base, especially routines to compose image data. Since Apple offers sophisticated SDKs for image processing which are only available on their plattforms, FITSKit tries to leverage on these as much as possbile to offer the best possible performance on Apple devices, especially iPadOS / iOS / macCatalina. 

### FITSTool
This package contains the code for a command line tool to read and write FITS files from the command line interface. This tool was written with Linux but does not (yet!) contain any Linsu specific dependencies.  

## Table of contents
* [Working with Files](DOCU_FILES.md)
* [Working with HDUs](DOCU_HDUS.md)
* [Working with Tables](DOCU_TABLES.md)

