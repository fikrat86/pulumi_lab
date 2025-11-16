# Quick Reference - Final Setup Steps

## ✅ Completed Steps
1. ✅ ESC environment created: `fikrat86/aws-dev-oidc`
2. ✅ ESC environment linked to stack `dev`
3. ✅ `Pulumi.dev.yaml` updated with environment reference

## 🔧 REQUIRED: Configure ESC Environment in Pulumi Cloud

The ESC environment needs to be configured with the YAML definition in the Pulumi Cloud Console.

### Steps:

1. **Go to Pulumi Cloud Console:**
   - URL: https://app.pulumi.com/fikrat86/environments/aws-dev-oidc
   - Or navigate: Pulumi Cloud → Settings → Environments → aws-dev-oidc

2. **Click "Edit" and paste this YAML:**

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

3. **Click "Save"**

## 🧪 Test OIDC Authentication

After saving the environment configuration, test it:

```powershell
# Navigate to your project
cd "c:\Users\fikra\Documents\Lesson\Cloud_Computing\Fall semester\Implementing DevOps Solutions-1209\Labs\Pulumi\ppinfra"

# Test environment opening (this will use OIDC to get AWS credentials)
pulumi env open aws-dev-oidc

# Preview your stack (tests OIDC authentication with AWS)
pulumi preview

# If preview works, deploy
pulumi up
```

## 🔍 Verify IAM Role Trust Policy

Make sure your `OIDC_Identity_Provider_Role` has this trust policy:

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

And ensure it has these permissions attached:
- `AmazonS3FullAccess`
- `CloudFrontFullAccess`

## 📝 Current Stack Configuration

Your `Pulumi.dev.yaml` is now configured with:

```yaml
config:
  aws:region: us-west-2
  myworkshop:errorDocument: error.html
  myworkshop:indexDocument: index.html
  myworkshop:path: ./www
environment:
  - aws-dev-oidc
```

## 🚀 Deploy Your Stack

Once the ESC environment is configured in Pulumi Cloud:

```powershell
# Preview changes
pulumi preview

# Deploy
pulumi up -y

# View outputs
pulumi stack output
```

Expected outputs:
- `cdnHostname`: Your CloudFront domain
- `cdnURL`: Full HTTPS URL to your website
- `originHostname`: S3 website endpoint
- `originURL`: S3 website URL

## 🐛 Troubleshooting

If `pulumi preview` fails with authentication errors:

1. Check ESC environment is properly configured in Pulumi Cloud
2. Verify IAM role trust policy includes the OIDC provider
3. Test AWS credentials:
   ```powershell
   pulumi env run aws-dev-oidc -- aws sts get-caller-identity
   ```

## 📚 Additional Resources

- Full setup guide: `SETUP-GUIDE.md`
- ESC environment definition: `esc-definition.yaml`
- Pulumi ESC Docs: https://www.pulumi.com/docs/esc/
