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

#スクリーンショット取得
Add-Type -AssemblyName System.Windows.Forms
click -x 235 -y 166
[System.Windows.Forms.SendKeys]::SendWait("^+I")
Start-Sleep -s 5
[System.Windows.Forms.SendKeys]::SendWait("^+P")
Start-Sleep -s 5
[System.Windows.Forms.SendKeys]::SendWait("Capture full size screenshot")
Start-Sleep -s 5
[System.Windows.Forms.SendKeys]::SendWait("~")
[System.Windows.Forms.SendKeys]::SendWait("~")
Start-Sleep -s 5
[System.Windows.Forms.SendKeys]::SendWait("{F12}")
Start-Sleep -s 10

#画像分割
Add-Type -AssemblyName System.Drawing
$pwd = pwd
$DownloadPath = "D:\ダウンロード\"
cd $DownloadPath
$SrcImagePath  = $DownloadPath + (Get-ChildItem -Filter *.png | Sort-Object LastWriteTime -Descending)[0].Name
cd $pwd
$SrcImage = [System.Drawing.Image]::FromFile($SrcImagePath)
[void][Reflection.Assembly]::LoadWithPartialName("System.Drawing")
$Rect = New-Object System.Drawing.Rectangle(165, 0, 1265, 1500)#生成したい画像の左上の座標と、そこからの大きさ
$DstImage = $SrcImage.Clone($Rect, $SrcImage.PixelFormat)
$DstImage.Save($DownloadPath + "CPU.png")

#リソースの解放
$SrcImage.Dispose()
$DstImage.Dispose()