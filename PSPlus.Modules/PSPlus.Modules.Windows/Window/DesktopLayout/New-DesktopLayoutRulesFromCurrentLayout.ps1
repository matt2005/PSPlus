function New-DesktopLayoutRulesFromCurrentLayout
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [string[]] $IncludeProcessNames = @(),

        [Parameter(Mandatory = $false)]
        [string[]] $ExcludeProcessNames = @(),

        [Parameter(Mandatory = $false)]
        [string[]] $IncludeClassNames = @(),

        [Parameter(Mandatory = $false)]
        [string[]] $ExcludeClassNames = @()
    )

    # Snap all processes
    $pidToProcessNameMap = Get-Process | ConvertTo-Dictionary { $_.Id } { $_.ProcessName }

    # Snap all top level windows
    $topLevelWindows = Get-Windows

    # Generate the window layout rules
    $windowLayoutRules = $topLevelWindows | ForEach-Object {
        $window = $_

        # Make sure the window is still alive while we are getting all the data
        if (-not $window.IsWindow()) {
            return
        }

        $isVisible = $window.IsWindowVisible()
        $windowPid = $window.GetWindowProcessId()
        $className = $window.GetClassName()
        $windowPlacement = $window.GetWindowPlacement()

        if (-not $window.IsWindow()) {
            return
        }

        # If the window is not visible, ignore. (Minimized windows will still have WS_VISIBLE style)
        if (-not $isVisible) {
            return
        }

        $windowProcessName = [string]::Empty;
        if (-not $pidToProcessNameMap.TryGetValue($windowPid, [ref] $windowProcessName)) {
            return
        }

        $isWindowProcessIncluded = Test-IsStringIncluded $windowProcessName $IncludeProcessNames $ExcludeProcessNames
        if (!$isWindowProcessIncluded) {
            return
        }

        $isClassNameIncluded = Test-IsStringIncluded $className $includeClassNames $excludeClassNames
        if (!$isClassNameIncluded) {
            return
        }

        $LayoutRuleFieldNames = [PSPlus.Core.Windows.Window.DesktopLayout.LayoutRuleFieldNames]
        $windowLayoutRule = @{
            $LayoutRuleFieldNames::Match = @{
                $LayoutRuleFieldNames::MatchProcessName = $windowProcessName
                $LayoutRuleFieldNames::MatchProcessNamePattern = $null
                $LayoutRuleFieldNames::MatchClassName = $className
                $LayoutRuleFieldNames::MatchClassNamePattern = $null
                $LayoutRuleFieldNames::MatchWindowTitlePattern = $null
            }
            $LayoutRuleFieldNames::Placement = @{
                $LayoutRuleFieldNames::PlacementWindowFlags = $windowPlacement.Flags
                $LayoutRuleFieldNames::PlacementWindowShowCmd = $windowPlacement.ShowCmd
                $LayoutRuleFieldNames::PlacementWindowMinPositionX = $windowPlacement.MinPosition.X
                $LayoutRuleFieldNames::PlacementWindowMinPositionY = $windowPlacement.MinPosition.Y
                $LayoutRuleFieldNames::PlacementWindowMaxPositionX = $windowPlacement.MaxPosition.X
                $LayoutRuleFieldNames::PlacementWindowMaxPositionY = $windowPlacement.MaxPosition.Y
                $LayoutRuleFieldNames::PlacementWindowNormalPositionLeft = $windowPlacement.NormalPosition.Left
                $LayoutRuleFieldNames::PlacementWindowNormalPositionTop = $windowPlacement.NormalPosition.Top
                $LayoutRuleFieldNames::PlacementWindowNormalPositionRight = $windowPlacement.NormalPosition.Right
                $LayoutRuleFieldNames::PlacementWindowNormalPositionBottom = $windowPlacement.NormalPosition.Bottom
            }
        }

        return $windowLayoutRule
    } 

    return $windowLayoutRules
}

function Test-IsClassNameIncluded($window, $includeClassNames, $excludeClassNames) {
    if (-not $window.IsWindow()) {
        return $false
    }

    $className = $window.GetClassName()
    return Test-IsStringIncluded $className $includeClassNames $excludeClassNames
}

function Test-IsStringIncluded([string] $s, [string[]] $includeRegexes, [string[]] $excludeRegexes) {
    if ($includeRegexes -ne $null -and $includeRegexes.Count -gt 0) {
        $isStringIncluded = $includeRegexes | Test-Any { Select-String -InputObject $s -Pattern $_ -Quiet }
        if (!$isStringIncluded) {
            return $false
        }
    }

    if ($excludeRegexes -ne $null -and $excludeRegexes.Count -gt 0) {
        $isStringExcluded = $excludeRegexes | Test-Any { Select-String -InputObject $s -Pattern $_ -Quiet }
        if ($isStringExcluded) {
            return $false
        }
    }

    return $true
}
