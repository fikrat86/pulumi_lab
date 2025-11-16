# Manual ESC Environment Setup Guide

## Method 1: Using Pulumi Cloud Console (EASIEST)

### Step 1: Login to Pulumi Cloud
1. Open your browser and go to: **https://app.pulumi.com/fikrat86**
2. Click on **"Environments"** in the left sidebar (or go to Settings)

### Step 2: Find Your Environment
1. Look for the environment named: **aws-dev-oidc**
2. Click on it

### Step 3: Edit the Environment
1. Click the **"Edit Definition"** button (top right)
2. You'll see a YAML editor

### Step 4: Paste This Configuration

**DELETE everything in the editor** and paste this:

```yaml
values:
  aws:
    login:
      fn::open::aws-login:
        oidc:
          roleArn: arn:aws:iam::949848044200:role/OIDC_Identity_Provider_Role
          sessionName: pulumi-environments-session
          duration: 1h
  environmentVariables:
    AWS_ACCESS_KEY_ID: ${aws.login.accessKeyId}
    AWS_SECRET_ACCESS_KEY: ${aws.login.secretAccessKey}
    AWS_SESSION_TOKEN: ${aws.login.sessionToken}
    AWS_REGION: us-west-2
  pulumiConfig:
    aws:region: us-west-2
```

### Step 5: Save
1. Click **"Save"** button at the bottom
2. You should see "Environment updated successfully"

---

## Method 2: Using PowerShell Script

Run this in PowerShell:

```powershell
cd "c:\Users\fikra\Documents\Lesson\Cloud_Computing\Fall semester\Implementing DevOps Solutions-1209\Labs\Pulumi"
.\set-esc-env.ps1
```

This will:
- Create a temporary YAML file with the correct configuration
- Open it in Notepad
- Show you the next steps

---

## Method 3: Direct API Call (Advanced)

If the above methods don't work, use Pulumi's REST API:

```powershell
# Get your Pulumi access token
$token = pulumi config get --show-secrets pulumi:access-token

# Or set it manually
$token = "YOUR_PULUMI_ACCESS_TOKEN"

# Set the environment definition
$yamlContent = Get-Content "esc-definition.yaml" -Raw

$headers = @{
    "Authorization" = "token $token"
    "Content-Type" = "application/json"
}

$body = @{
    "yaml" = $yamlContent
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://api.pulumi.com/api/preview/environments/fikrat86/default/aws-dev-oidc/versions" -Method POST -Headers $headers -Body $body
```

---

## Verification

After setting the environment, verify it works:

```powershell
cd "c:\Users\fikra\Documents\Lesson\Cloud_Computing\Fall semester\Implementing DevOps Solutions-1209\Labs\Pulumi\ppinfra"

# Check environment content
pulumi env get aws-dev-oidc

# Open environment (this will authenticate with AWS via OIDC)
pulumi env open aws-dev-oidc

# Test with your stack
pulumi preview
```

---

## Expected Output from `pulumi env get aws-dev-oidc`

You should see:

```yaml
{
  "aws": {
    "login": {
      "accessKeyId": "ASIA...",
      "secretAccessKey": "...",
      "sessionToken": "..."
    }
  },
  "environmentVariables": {
    "AWS_ACCESS_KEY_ID": "ASIA...",
    "AWS_REGION": "us-west-2",
    "AWS_SECRET_ACCESS_KEY": "...",
    "AWS_SESSION_TOKEN": "..."
  },
  "pulumiConfig": {
    "aws:region": "us-west-2"
  }
}
```

---

## Troubleshooting

### If you can't see the Pulumi Cloud Console properly:

1. Try a different browser
2. Clear browser cache
3. Use incognito/private mode
4. Check if you're logged in to the correct account: **fikrat86**

### If the environment editor is blank:

This is normal for a new environment. Just paste the YAML configuration and save.

### If you get "unauthorized" errors:

1. Check you're logged in: `pulumi whoami`
2. Re-login: `pulumi login`

---

## Quick Copy-Paste Configuration

Copy everything between the dashed lines:

---START---
```
values:
  aws:
    login:
      fn::open::aws-login:
        oidc:
          roleArn: arn:aws:iam::949848044200:role/OIDC_Identity_Provider_Role
          sessionName: pulumi-environments-session
          duration: 1h
  environmentVariables:
    AWS_ACCESS_KEY_ID: ${aws.login.accessKeyId}
    AWS_SECRET_ACCESS_KEY: ${aws.login.secretAccessKey}
    AWS_SESSION_TOKEN: ${aws.login.sessionToken}
    AWS_REGION: us-west-2
  pulumiConfig:
    aws:region: us-west-2
```
---END---

Paste this at: https://app.pulumi.com/fikrat86/environments/aws-dev-oidc (click Edit Definition)
