# Pulumi ESC with AWS OIDC Setup Guide

## Prerequisites
✅ AWS IAM OIDC Identity Provider created
- Provider URL: `https://token.actions.githubusercontent.com`
- Audience: `sts.amazonaws.com`
- Role: `OIDC_Identity_Provider_Role`

## Step 1: Create Pulumi ESC Environment

### Option A: Via Pulumi Cloud Console (Recommended)
1. Go to https://app.pulumi.com/
2. Navigate to **Settings** → **Environments**
3. Click **Create Environment**
4. Name: `aws-dev-oidc`
5. Copy and paste the content from `esc-environment.yaml` into the editor
6. Click **Save**

### Option B: Via Pulumi CLI
```powershell
# Login to Pulumi
pulumi login

# Create the ESC environment
pulumi env init aws-dev-oidc

# Edit the environment (opens in editor)
pulumi env edit aws-dev-oidc
# Paste the content from esc-environment.yaml, save and close

# Verify the environment
pulumi env open aws-dev-oidc
```

## Step 2: Link ESC Environment to Your Stack

Navigate to your project directory and run:

```powershell
cd "c:\Users\fikra\Documents\Lesson\Cloud_Computing\Fall semester\Implementing DevOps Solutions-1209\Labs\Pulumi\ppinfra"

# Import the ESC environment into your stack
pulumi config env add aws-dev-oidc
```

This will update your `Pulumi.dev.yaml` to include:
```yaml
environment:
  - aws-dev-oidc
```

## Step 3: Verify OIDC Configuration

Test that the OIDC authentication works:

```powershell
# Check if environment is loaded
pulumi env open aws-dev-oidc

# Preview your stack (this will use OIDC to authenticate)
pulumi preview

# If preview works, deploy
pulumi up
```

## Step 4: Update Stack Configuration (if needed)

Your `Pulumi.dev.yaml` should look like:

```yaml
environment:
  - aws-dev-oidc
config:
  aws:region: us-west-2
  myworkshop:errorDocument: error.html
  myworkshop:indexDocument: index.html
  myworkshop:path: ./www
```

## Troubleshooting

### If OIDC authentication fails:

1. **Verify IAM Role Trust Policy:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::949848044200:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
```

2. **Verify IAM Role Permissions:**
Ensure `OIDC_Identity_Provider_Role` has necessary permissions:
- `AmazonS3FullAccess` (for S3 bucket operations)
- `CloudFrontFullAccess` (for CloudFront distribution)
- Or create a custom policy with minimum required permissions

3. **Check Pulumi ESC Environment:**
```powershell
pulumi env get aws-dev-oidc
```

4. **Test AWS credentials:**
```powershell
# This should use OIDC to get temporary credentials
pulumi env run aws-dev-oidc -- aws sts get-caller-identity
```

## Environment Variables

When the ESC environment is active, these variables are automatically set:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN`
- `AWS_REGION`

## Testing the Complete Setup

```powershell
# 1. Navigate to project
cd "c:\Users\fikra\Documents\Lesson\Cloud_Computing\Fall semester\Implementing DevOps Solutions-1209\Labs\Pulumi\ppinfra"

# 2. Preview changes (tests OIDC auth)
pulumi preview

# 3. Deploy the stack
pulumi up -y

# 4. View outputs
pulumi stack output
```

## Expected Output

After successful deployment:
- `cdnHostname`: CloudFront distribution domain
- `cdnURL`: Full HTTPS URL to your website via CloudFront
- `originHostname`: S3 website endpoint
- `originURL`: Direct S3 website URL

## Next Steps

1. ✅ ESC environment created
2. ✅ OIDC configured
3. ✅ Stack linked to ESC
4. Test deployment
5. Set up GitHub Actions (optional)

## GitHub Actions Integration (Optional)

If you want to deploy from GitHub Actions, create `.github/workflows/pulumi.yml`:

```yaml
name: Pulumi Deploy
on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      
      - name: Install Pulumi CLI
        uses: pulumi/actions@v5
      
      - name: Deploy with Pulumi
        run: |
          cd ppinfra
          npm install
          pulumi preview
        env:
          PULUMI_ACCESS_TOKEN: ${{ secrets.PULUMI_ACCESS_TOKEN }}
```
