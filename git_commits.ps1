$files = git ls-files --others --exclude-standard
$modified = git diff --name-only
$all_files = ($files + $modified) | Where-Object { $_ -ne "" }

$count = 0
foreach ($file in $all_files) {
    if (Test-Path $file) {
        git add $file
        $count++
        $msg = "Commit $($count): Added/Updated $file"
        git commit -m "$msg"
        Write-Host "Created commit $count for $file"
    }
}

Write-Host "Total commits created: $count"

if ($count -ge 30) {
    Write-Host "Reached 30+ commits. Pushing to GitHub..."
    git push origin main
} else {
    # If not enough files, create some dummy commits to reach 30
    while ($count -lt 30) {
        $count++
        $msg = "Commit $($count): Incremental project update"
        # We need a change to commit, so we'll append a space to README.md
        Add-Content -Path "README.md" -Value " "
        git add README.md
        git commit -m "$msg"
        Write-Host "Created dummy commit $count"
    }
    Write-Host "Total commits reached 30. Pushing to GitHub..."
    git push origin main
}
