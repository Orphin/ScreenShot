function click{
param($x, $y)

# .NET Frameworkの宣言
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

# Windows APIの宣言
$signature=@'
[DllImport("user32.dll",CharSet=CharSet.Auto,CallingConvention=CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@
$SendMouseClick = Add-Type -memberDefinition $signature -name "Win32MouseEventNew" -namespace Win32Functions -passThru

Start-Sleep -s 1

# マウスカーソル移動
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)

# 左クリック
$SendMouseClick::mouse_event(0x0002, 0, 0, 0, 0);
$SendMouseClick::mouse_event(0x0004, 0, 0, 0, 0);
}

function CFSS{
#スクリーンショット取得
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("^+P")
Start-Sleep -s 5
[System.Windows.Forms.SendKeys]::SendWait("Capture full size screenshot")
Start-Sleep -s 5
[System.Windows.Forms.SendKeys]::SendWait("~")
[System.Windows.Forms.SendKeys]::SendWait("~")
Start-Sleep -s 10
}

Add-Type -AssemblyName System.Drawing
function ImageSeparate{
param($ImageName, $LeftUpX, $LeftUpY, $RightDownX, $RightDownY)

#画像分割
$pwd = pwd
$DownloadPath = "D:\ダウンロード\"
cd $DownloadPath
$SrcImagePath  = $DownloadPath + (Get-ChildItem -Filter *.png | Sort-Object LastWriteTime -Descending)[0].Name
cd $pwd
$SrcImage = [System.Drawing.Image]::FromFile($SrcImagePath)
[void][Reflection.Assembly]::LoadWithPartialName("System.Drawing")
$Rect = New-Object System.Drawing.Rectangle($LeftUpX, $LeftUpY, ($RightDownX - $LeftUpX), ($RightDownY - $LeftUpY))
$DstImage = $SrcImage.Clone($Rect, $SrcImage.PixelFormat)
$DstImage.Save($DownloadPath + "${ImageName}.png")

#リソースの解放
$SrcImage.Dispose()
$DstImage.Dispose()
}

click -x 2682 -y 184

#開発者モード起動
[System.Windows.Forms.SendKeys]::SendWait("^+I")
Start-Sleep -s 5

CFSS
ImageSeparate -ImageName Temp1 -LeftUpX 0 -LeftUpY 0 -RightDownX 100 -RightDownY 200

click -x 2682 -y 184
[System.Windows.Forms.SendKeys]::SendWait("{Down} 5")

CFSS
ImageSeparate -ImageName Temp2 -LeftUpX 100 -LeftUpY 200 -RightDownX 200 -RightDownY 400

#開発者モード終了
[System.Windows.Forms.SendKeys]::SendWait("{F12}")
