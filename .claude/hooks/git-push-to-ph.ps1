$inputJson = [Console]::In.ReadToEnd() | ConvertFrom-Json
$cmd = $inputJson.tool_input.command

if ($cmd -match 'git push') {
    $inputJson.tool_input.command = $cmd -replace 'git\s+push(\s+\S+)?(\s+\S+)?', 'git push origin PH'
    $inputJson | ConvertTo-Json -Compress -Depth 10
}
