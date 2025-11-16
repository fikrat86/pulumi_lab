# AWS IAM Trust Policy Update for Pulumi ESC OIDC

## Problem
Your IAM role `OIDC_Identity_Provider_Role` currently trusts GitHub's OIDC provider, but Pulumi ESC uses its own OIDC provider at `api.pulumi.com/oidc`.

## Solution

### Step 1: Create Pulumi OIDC Provider in AWS (if not exists)

Run this AWS CLI command to create the OIDC provider:

```powershell
aws iam create-open-id-connect-provider `
  --url https://api.pulumi.com/oidc `
  --client-id-list fikrat86 `
  --thumbprint-list 9e99a48a9960b14926bb7f3b02e22da2b0ab7280
```

**Note:** The thumbprint `9e99a48a9960b14926bb7f3b02e22da2b0ab7280` is for api.pulumi.com.

### Step 2: Update IAM Role Trust Policy

You have two options:

#### Option A: Via AWS Console

1. Go to AWS IAM Console: https://console.aws.amazon.com/iam/
2. Navigate to **Roles** → **OIDC_Identity_Provider_Role**
3. Click on **Trust relationships** tab
4. Click **Edit trust policy**
5. Replace with this JSON:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::949848044200:oidc-provider/api.pulumi.com/oidc"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "api.pulumi.com/oidc:aud": "fikrat86"
        }
      }
    }
  ]
}
```

6. Click **Update policy**

#### Option B: Via AWS CLI

```powershell
cd "c:\Users\fikra\Documents\Lesson\Cloud_Computing\Fall semester\Implementing DevOps Solutions-1209\Labs\Pulumi"

aws iam update-assume-role-policy `
  --role-name OIDC_Identity_Provider_Role `
  --policy-document file://pulumi-trust-policy.json
```

### Step 3: Verify the Setup

After updating the trust policy, test locally:

```powershell
cd "c:\Users\fikra\Documents\Lesson\Cloud_Computing\Fall semester\Implementing DevOps Solutions-1209\Labs\Pulumi\ppinfra"

# This should now work without errors
pulumi preview
```

### Step 4: Test Pulumi Deployments

Once local preview works, trigger a deployment from Pulumi Cloud or push a commit to GitHub.

## Important Notes

### Subject Pattern for Pulumi ESC

Pulumi ESC OIDC subject follows this pattern:
- **For environments:** `pulumi:environments:org:fikrat86:env:default/aws-dev-oidc`
- **For deployments:** `pulumi:deploy:org:fikrat86:stack:static-website-aws-typescript/dev`

### More Restrictive Trust Policy (Optional)

For better security, you can restrict to specific environments:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::949848044200:oidc-provider/api.pulumi.com/oidc"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "api.pulumi.com/oidc:aud": "fikrat86",
          "api.pulumi.com/oidc:sub": "pulumi:environments:org:fikrat86:env:default/aws-dev-oidc"
        }
      }
    }
  ]
}
```

## Troubleshooting

### Error: "Not authorized to perform sts:AssumeRoleWithWebIdentity"

This means:
1. The OIDC provider doesn't exist in AWS
2. The trust policy is incorrect
3. The audience or subject doesn't match

### Check OIDC Provider Exists

```powershell
aws iam list-open-id-connect-providers
```

You should see: `arn:aws:iam::949848044200:oidc-provider/api.pulumi.com/oidc`

### Get Current Trust Policy

```powershell
aws iam get-role --role-name OIDC_Identity_Provider_Role --query 'Role.AssumeRolePolicyDocument'
```

## References

- Pulumi ESC OIDC Documentation: https://www.pulumi.com/docs/pulumi-cloud/oidc/provider/aws/
- AWS IAM OIDC: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html
