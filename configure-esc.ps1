@"
# =====================================================
# Pulumi ESC Environment Configuration
# =====================================================
# 
# Copy the YAML below and paste it into Pulumi Cloud Console
#
# URL: https://app.pulumi.com/fikrat86/environments/aws-dev-oidc
# 
# Steps:
# 1. Click "Edit Definition"
# 2. Delete any existing content
# 3. Paste the YAML below
# 4. Click "Save"
#
# =====================================================

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

# =====================================================
# After saving, verify with:
# pulumi env get fikrat86/aws-dev-oidc
# =====================================================
"@

Write-Host "Opening Pulumi Cloud Console in browser..."
Start-Process "https://app.pulumi.com/fikrat86/environments/aws-dev-oidc"

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "PULUMI ESC CONFIGURATION" -ForegroundColor Cyan  
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. A browser window should open to edit the environment" -ForegroundColor Yellow
Write-Host "2. Click 'Edit Definition' button" -ForegroundColor Yellow
Write-Host "3. Copy the YAML below and paste it:" -ForegroundColor Yellow
Write-Host ""
Write-Host "values:" -ForegroundColor Green
Write-Host "  aws:" -ForegroundColor Green
Write-Host "    login:" -ForegroundColor Green
Write-Host "      fn::open::aws-login:" -ForegroundColor Green
Write-Host "        oidc:" -ForegroundColor Green
Write-Host "          roleArn: arn:aws:iam::949848044200:role/OIDC_Identity_Provider_Role" -ForegroundColor Green
Write-Host "          sessionName: pulumi-environments-session" -ForegroundColor Green
Write-Host "          duration: 1h" -ForegroundColor Green
Write-Host "  environmentVariables:" -ForegroundColor Green
Write-Host "    AWS_ACCESS_KEY_ID: `${aws.login.accessKeyId}" -ForegroundColor Green
Write-Host "    AWS_SECRET_ACCESS_KEY: `${aws.login.secretAccessKey}" -ForegroundColor Green
Write-Host "    AWS_SESSION_TOKEN: `${aws.login.sessionToken}" -ForegroundColor Green
Write-Host "    AWS_REGION: us-west-2" -ForegroundColor Green
Write-Host "  pulumiConfig:" -ForegroundColor Green
Write-Host "    aws:region: us-west-2" -ForegroundColor Green
Write-Host ""
Write-Host "4. Click 'Save'" -ForegroundColor Yellow
Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
