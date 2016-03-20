function do_off
{
$json = '{"on":false}'
callhue
}
function do_on
{
$json = '{"on":true}'
callhue
}
function do_random
{
$json = '{"on":true,"effect":"colorloop"}'
callhue
}
function do_brit
{
$json = '{"on":true,"bri":'+$brithue+'}'
callhue
}
function PickColor
{
    $colorDialog = new-object System.Windows.Forms.ColorDialog
    $colorDialog.AllowFullOpen = $true
    $colorDialog.ShowDialog()
    $alpha = $colordialog.color.A
    [Double]$red = $colordialog.color.R
    [Double]$green = $colordialog.color.G
    [Double]$blue = $colordialog.color.B
    $error.clear()
	do_color
}
function do_color
{
$X = 0.4124*$red + 0.3576*$green + 0.1805*$blue
$Y = 0.2126*$red + 0.7152*$green + 0.0722*$blue
$Z = 0.0193*$red + 0.1192*$green + 0.9505*$blue
$xh = $x / ($x + $y + $z)
$yh = $y / ($x + $z + $z)
$json='{"on":true,"effect":"none","xy":['+$xh+','+$yh+']}'
callhue
}
function callhue
{
Invoke-WebRequest -UseBasicParsing -ContentType "application/json" -Body $json -Uri "http://$iphue/api/newdeveloper/groups/0/action" -Method Put
}
[reflection.assembly]::LoadWithPartialName( "System.Windows.Forms")
$form= New-Object Windows.Forms.Form
$toolTip = New-Object System.Windows.Forms.ToolTip
$form.Text = "By Dav.Robin.free.fr"
$form.Width = 200
$form.Height = 200
$form.Opacity = 0.7
$form.MinimizeBox = $False
$form.MaximizeBox = $False
$form.FormBorderStyle = 'Fixed3D'
$lpath=pwd
$Image = [system.drawing.image]::FromFile("$lpath\fond.jpeg")
$form.BackgroundImage = $Image
$Icon = New-Object system.drawing.icon ("$lpath\hue.ico")
$form.Icon = $Icon
$form.StartPosition = "CenterScreen"
$Form.Add_Shown({$Form.Activate()})
$Label = New-Object System.Windows.Forms.LinkLabel
$label.location = New-Object System.Drawing.Size(35,75)
$label.TextAlign = "MiddleCenter"
$toolTip.SetToolTip($label,"Pimp it !")
$buttonoff = New-Object Windows.Forms.Button
$buttonoff.location = New-Object System.Drawing.Size(110,0)
$toolTip.SetToolTip($buttonoff,"Sleep !")
$buttonr = New-Object Windows.Forms.Button
$buttonr.location = New-Object System.Drawing.Size(50,100)
$toolTip.SetToolTip($buttonr,"Let's ColorLoop !")
$buttonc = New-Object Windows.Forms.Button
$buttonc.location = New-Object System.Drawing.Size(50,45)
$toolTip.SetToolTip($buttonc,"Pick Color!")
$buttonon = New-Object Windows.Forms.Button
$toolTip.SetToolTip($buttonon,"Wake Up !")
$brit = New-Object Windows.Forms.TrackBar
$brit.location = New-Object System.Drawing.Size(0,135)
$brit.SetRange(0,255)
$brit.Value = 200
$toolTip.SetToolTip($brit,"$brit.Value")
$brit.Width = 180
$buttonon.text = "ON !"
$buttonoff.text = "OFF !"
$buttonr.text = "RANDOM"
$buttonc.text = "COLOR"
$buttonon.add_click({do_on})
$buttonoff.add_click({do_off})
$buttonr.add_click({do_random})
$buttonc.add_click({PickColor})
$Form.Controls.Add($Label)
$form.controls.add($buttonc)
$form.controls.add($buttonon)
$form.controls.add($buttonoff)
$form.controls.add($buttonr)
$form.controls.add($brit)
$brit.add_ValueChanged({
$brithue = $brit.Value
do_brit
})
$a=Invoke-WebRequest -UseBasicParsing -ContentType "application/json" -Uri "https://www.meethue.com/api/nupnp" -Method Get
$iphue=$a.Content.split('"')[7]
$Label.Text = "IP:" + $iphue
$Label.add_Click({[system.Diagnostics.Process]::start("http://$iphue/debug/clip.html")})
$json = '{"on":true,"alert":"select"}'
$check=Invoke-WebRequest -UseBasicParsing -ContentType "application/json" -Body $json -Uri "http://$iphue/api/newdeveloper/groups/0/action" -Method Put
if ($check.Content -like "*unauthorized*"){
$form.Show()
$Label.Location = New-Object System.Drawing.Size(0,0) 
$Label.Size = New-Object System.Drawing.Size(200,200)
$Label.Font = New-object System.Drawing.Font('Calibri', 20, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Point,0) 
$json='{"devicetype":"test user","username":"newdeveloper"}'
Invoke-WebRequest -UseBasicParsing -ContentType "application/json" -Body $json -Uri "http://$iphue/api/" -Method Post
$i=30
DO{
Start-Sleep -s 1
$Label.Text="Press HUB hue buttom " + $i + "s. left"
$i = $i-1
$check=Invoke-WebRequest -UseBasicParsing -ContentType "application/json" -Body $json -Uri "http://$iphue/api/" -Method Post
}Until($check.Content -like "*newdeveloper*")
$Label.Text="Good ! Launch Again Please"
Start-Sleep -s 3
}
$check=Invoke-WebRequest -UseBasicParsing -ContentType "application/json" -Body $json -Uri "http://$iphue/api/newdeveloper/groups/0/action" -Method Put
$Label.Size = New-Object System.Drawing.Size(100,20)
$form.ShowDialog()


