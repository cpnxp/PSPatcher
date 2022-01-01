# PSPatcher

A simple PowerShell based binary patcher

## Description

The goal of this project is to have a light weight solution for making and distributing simple
binary patches with minimal overhead.  This removes the need to send entire copies of a binary.
The PSPatcher file format .PSP is based on an INI file to make them easy to write manually.
Note this is intended for advanced users, if you are not comfortable Hex editing or do not
understand the implication of your changes, this tool is not for you. This tool is very
simple so it is not very capable, it was designed to be simple so as to not make this easy
process more complex. PSPatcher will not be suited to anything that is more complex than
changing a handful of hex offsets.

Do note that when writing the patched file out the performance isn't great so it could take
awhile with large binaries.  This loads the complete binary into RAM so make sure you have
enough RAM.

Requires Module: PsIni which can be installed from the PowerShell Gallery

```PowerShell
Install-Module PsIni
```

## PSP File Format

A PSP file is an INI file with specific sections that are mandated. here is an example:

```INI
[metadata]
name=Simple Game Patch
author=CPNXP

[checksum]
original=0946867323AAC4DF0A72C80CD84951B188A46B5067B4D20CC1038726DB1720DA
patched=472F4D78BCF918221E2291C3E3AE568F564700AF7D4FF480C8D60209FDE8AB4C

[hexedit]
0x1F5E13=0x30
0x1F5E15=0x30
```

### metadata

The metadata section should have a name field and author field, these can be arbitrary strings.
This is mainly to help identify what the patch is for.

### checksum

The checksum section is one of the most critical as it is how the function determines if the patching was
successful. Both are SHA256 hashes. original is the hash of the file before it was patched while patched
is what the hash of the binary should be after it is hashed.

### hexedit

hexedit is a bunch of pairs of offsets and Byte values in Hex format.  This is the core of how PSPatcher works
once you have identified the values you want to hex edit, you can then list them in the format of

`<offset>=<byte>`

one per line
