
Quicklinks : [Introducion](DOCU_INTRO.md) | [Files](DOCU_FILES.md) | [Files](DOCU_HDUS.md) | [Tables](DOCU_TABLES.md)

# Working with HDUs

Since a FITS file is simply a sequence of **H**eader **D**ata **U**nits, lets taks about these. HDUs are basically a sequence of meta Information in blocks of 80 (ASCII) characters followed by the binary data block containing the stored information.

There are severa classes implemeting HDU properties
* **[AnyHDU](../Sources/FITS/HDU/AnyHDU.swift)** impelements is an `open class` with everything needed to read and write [HeaderBlocks](../Sources/FITS/HDU/HeaderBlock.swift) and dataUnit
* **[AnyImageHDU](../Sources/FITS/HDU/AnyImageHDU.swift)** implements routines for reading from and setting data to the dataUnit shared between `PrimaryHDU` and `ImageHDU`

## Header Blocks

Headers are treated as a fully flexible list of Keywords with values and comments. Following the FITS standard, there are Keywords with special semantics to them like `BITPIX` and `NAXIS`. All those can be fully modified by without any interference. But be aware before writing files, the validation-routine takes will check basic file integriy and modify two headers:
* The `SIMPLE` keyworld will be set to `T` or `F` based on the success of the file validation
* The `END` keyword will always be moved to the end to conclude the list 

## Primary HDU

The [`PrimaryHDU`](../Sources/FITS/HDU/PrimaryHDU.swift) is required in every [FITSFile](../Sources/FITS/FITSFile.swift). 

## Image Extensions

The [`ImageHDU`](../Sources/FITS/HDU/ImageHDU.swift) offers routines for reading and writing Image extensions via the routines implemented in `AnyImageHDU`. 

## Table Extensions

The [`TableHDU`](../Sources/FITS/HDU/TableHDU.swift) offers routines for reading and writng Table extensions

## Bintable Extensions

The [`BintableHDU`](../Sources/FITS/HDU/BintableHDU.swift) offers routines for reading and writng Table extensions
