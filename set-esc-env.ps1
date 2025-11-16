# Script to set Pulumi ESC Environment Configuration

$envContent = @"
values:
  aws:
    login:
      fn::open::aws-login:
        oidc:
          roleArn: arn:aws:iam::949848044200:role/OIDC_Identity_Provider_Role
          sessionName: pulumi-environments-session
          duration: 1h
  environmentVariables:
    AWS_ACCESS_KEY_ID: `${aws.login.accessKeyId}
    AWS_SECRET_ACCESS_KEY: `${aws.login.secretAccessKey}
    AWS_SESSION_TOKEN: `${aws.login.sessionToken}
    AWS_REGION: us-west-2
  pulumiConfig:
    aws:region: us-west-2
"@

# Save to temporary file
$tempFile = [System.IO.Path]::GetTempFileName()
$yamlFile = $tempFile + ".yaml"
Move-Item $tempFile $yamlFile -Force
$envContent | Out-File -FilePath $yamlFile -Encoding UTF8 -NoNewline

Write-Host "Environment configuration saved to: $yamlFile"
Write-Host ""
Write-Host "Now run this command to set the environment:"
Write-Host "pulumi env edit fikrat86/aws-dev-oidc --editor `"notepad.exe $yamlFile`""
Write-Host ""
Write-Host "Or manually copy the content from: $yamlFile"
Write-Host "And paste it in Pulumi Cloud Console at:"
Write-Host "https://app.pulumi.com/fikrat86/environments/aws-dev-oidc"

# Open notepad with the file
notepad.exe $yamlFile
