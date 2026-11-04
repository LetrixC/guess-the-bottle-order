# Builds the combined "Screens:" YAML that can be pasted into Power Apps Studio in one go.
#   00-AllScreens.yaml      all 5 screens (English connector name Office365Users)
#   00-Paste-Online.yaml    only the screens changed for online Duo, with the connector name
#                           passed in -UsersConnector (e.g. Office365使用者 in a zh-TW Studio)
param([string]$UsersConnector = 'Office365Users')

$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$utf8 = New-Object System.Text.UTF8Encoding $false

$gameOnVisible = @'
      OnVisible: |-
        =If(
            gMode = "ONLINE",
            Clear(colHistory);
            Set(gTurn, gGame.Turn); Set(gSeat, gGame.Seat); Set(gWin, false);
            Set(gC1, Value(Index(Split(gGame.Secret, ","), 1).Value));
            Set(gC2, Value(Index(Split(gGame.Secret, ","), 2).Value));
            Set(gC3, Value(Index(Split(gGame.Secret, ","), 3).Value));
            Set(gC4, Value(Index(Split(gGame.Secret, ","), 4).Value));
            UpdateContext({locS1: 0, locS2: 0, locS3: 0, locS4: 0, locHandoff: false}),
            With({s: FirstN(Shuffle(Bottles), 4)},
                Set(gC1, Index(s, 1).Id); Set(gC2, Index(s, 2).Id);
                Set(gC3, Index(s, 3).Id); Set(gC4, Index(s, 4).Id)
            );
            Clear(colHistory);
            Set(gTurn, 1); Set(gSeat, 1); Set(gWin, false);
            UpdateContext({locS1: 0, locS2: 0, locS3: 0, locS4: 0, locHandoff: gMode = "DUO"})
        )
'@

$screens = [ordered]@{
    scrHome   = '02-scrHome.yaml'
    scrTeam   = '03-scrTeam.yaml'
    scrLobby  = '03b-scrLobby.yaml'
    scrGame   = '04-scrGame.yaml'
    scrResult = '05-scrResult.yaml'
}

function Build([string[]]$names, [string]$connector) {
    $sb = New-Object System.Text.StringBuilder
    [void]$sb.Append("Screens:`n")
    foreach ($n in $names) {
        [void]$sb.Append("  ${n}:`n    Properties:`n      Fill: =C_Black`n")
        if ($n -eq 'scrGame') { [void]$sb.Append($gameOnVisible.Replace("`r`n", "`n").TrimEnd() + "`n") }
        [void]$sb.Append("    Children:`n")
        foreach ($line in [IO.File]::ReadAllLines((Join-Path $dir $screens[$n]), $utf8)) {
            if ($line.Trim().StartsWith('#')) { continue }
            if ($line -eq '') { [void]$sb.Append("`n"); continue }
            [void]$sb.Append('      ' + $line + "`n")
        }
    }
    $sb.ToString().Replace('Office365Users.', "$connector.")
}

[IO.File]::WriteAllText((Join-Path $dir '00-AllScreens.yaml'), (Build @($screens.Keys) 'Office365Users'), $utf8)
[IO.File]::WriteAllText((Join-Path $dir '00-Paste-Online.yaml'), (Build @('scrTeam', 'scrLobby', 'scrGame', 'scrResult') $UsersConnector), $utf8)
