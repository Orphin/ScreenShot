﻿[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

Start-Sleep -s 3

$X = [System.Windows.Forms.Cursor]::Position.X
$Y = [System.Windows.Forms.Cursor]::Position.Y

Write-Output "X: $X | Y: $Y"
Read-Host