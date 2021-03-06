#
# Module manifest for module 'PSPlus.Tfs'
#

@{

# Script module or binary module file associated with this manifest.
# RootModule = 'Module.psd1'

# Version number of this module.
ModuleVersion = '0.1.0.100'

# ID used to uniquely identify this module
GUID = '53AAE980-FBE6-4A14-9363-93D4AD0D4780'

# Author of this module
Author = 'r12f'

# Company or vendor of this module
CompanyName = ''

# Copyright statement for this module
Copyright = '(c) 2017 r12f. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Team foundation server related cmdlets!'

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
TypesToProcess = @(
    "PSPlus.Tfs.Types.ps1xml"
)

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = @(
    "PSPlus.Tfs.Format.ps1xml"
)

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @(
    "PSPlus.Modules.Tfs.psd1"
)

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = '*'

# Cmdlets to export from this module
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = '*'

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
