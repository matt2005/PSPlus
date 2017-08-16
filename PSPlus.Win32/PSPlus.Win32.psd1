#
# Module manifest for module 'PSPlus.Core'
#

@{

# Script module or binary module file associated with this manifest.
# RootModule = 'Module.psd1'

# Version number of this module.
ModuleVersion = '0.0.1.100'

# ID used to uniquely identify this module
GUID = 'C0A0E580-566D-4D14-98ED-1DC3A87CECCB'

# Author of this module
Author = 'r12f'

# Company or vendor of this module
CompanyName = ''

# Copyright statement for this module
Copyright = '(c) 2017 r12f. All rights reserved.'

# Description of the functionality provided by this module
Description = 'PSPlus win32 functionalities.'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(
    "Powershell/PSPlus.Win32.dll",
    "Powershell/PSPlus.Win32.Consts.psm1"
)

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @()

# Cmdlets to export from this module
CmdletsToExport = @(
    'New-WindowControl',
    "Get-ForegroundWindow",
    "Get-DesktopWindow"
)

# Variables to export from this module
VariablesToExport = @(
    "Win32Consts"
)

# Aliases to export from this module
AliasesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess
# PrivateData = ''

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
