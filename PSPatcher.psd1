<#
    .SYNOPSIS
    PSPatcher - A simple PowerShell based binary patcher

    .DESCRIPTION
    The goal of this project is to have a light weight solution for makeing and distrubting simple
    binary patches with minimal overhead.  This removes the need to send entire copies of a binary.
    The PSPatcher file format .PSP is based on an INI file to make them easy to write manually.
    Note this is intended for advanced users, if you are not comfortable Hex editing or do not
    understand the implaciation of your changes, this tool is not for you. This tool is very
    simple so it is not very capable, it was designed to be simple so as to not make this easy
    process more complex.

    Do note that when writing the patched file out the performance isn't great so it could take
    awhile with large binaries.  This loads the complete binary into RAM so make sure you have
    enough RAM.

    Requires Module - PsIni which can be installed from the PowerShell Gallery
#>
@{

# Module Loader File
RootModule = 'Merge-PSPatch.psm1'

# Version Number
ModuleVersion = '1.0'

# Unique Module ID
GUID = '140b1fdc-4d66-4cb3-8f88-a4681b552e5f'

# Module Author
Author = 'CPNXP'

# Company
CompanyName = 'CPNXP'

# Copyright
Copyright = '(c) 2022 CPNXP. All rights reserved.'

# Module Description
Description = 'A simple PowerShell based binary patcher'

# Minimum PowerShell Version Required
PowerShellVersion = ''

# Name of Required PowerShell Host
PowerShellHostName = ''

# Minimum Host Version Required
PowerShellHostVersion = ''

# Minimum .NET Framework-Version
DotNetFrameworkVersion = ''

# Minimum CLR (Common Language Runtime) Version
CLRVersion = ''

# Processor Architecture Required (X86, Amd64, IA64)
ProcessorArchitecture = ''

# Required Modules (will load before this module loads)
RequiredModules = @('PsIni')

# Required Assemblies
RequiredAssemblies = @()

# PowerShell Scripts (.ps1) that need to be executed before this module loads
ScriptsToProcess = @()

# Type files (.ps1xml) that need to be loaded when this module loads
TypesToProcess = @()

# Format files (.ps1xml) that need to be loaded when this module loads
FormatsToProcess = @()

# 
NestedModules = @()

# List of exportable functions
FunctionsToExport = 'Merge-PSPatch'

# List of exportable cmdlets
CmdletsToExport = ''

# List of exportable variables
VariablesToExport = '*'

# List of exportable aliases
AliasesToExport = ''

# List of all modules contained in this module
ModuleList = @()

# List of all files contained in this module
FileList = @()

# Private data that needs to be passed to this module
PrivateData = ''

}