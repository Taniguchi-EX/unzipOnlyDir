# zipのパスを入力してもらう
Write-Host("zipファイルのパスを入力してください。")
$zipPath = Read-Host

# zipの存在確認
$isExt = (Test-Path $zipPath)
if (!$isExt) {
	Write-Host("対象のzipファイルが見つかりませんでした。終了します")
	Read-Host
	exit
}

# アセンブリを読み込む
add-type -assemblyname system.io.compression.filesystem
# フォルダリストを作る
$line = [io.compression.zipfile]::openread($zipPath).entries | Where-Object{ $_.name.length -eq 0} | Sort-Object
$folderList = $line -split "\\ "

# zipの親フォルダを特定
$zipParent = Split-Path $zipPath -Parent

# 親フォルダ直下に、行ごとにフォルダを生成
foreach($folder in $folderList){
	$target = $zipParent + "\" + $folder
	New-Item $target -itemType Directory -Force
}
Write-Host("フォルダの出力が完了しました。")

# 出力先のディレクトリを開く
$pathObject = [IO.FileInfo]$zipParent
Invoke-Item $pathObject
