# GitHub Actions Setup for iOS Build & TestFlight

This guide explains how to set up automated iOS builds and TestFlight deployment using GitHub Actions.

## Prerequisites

1. Apple Developer Account ($99/year)
2. App registered in App Store Connect
3. Signing certificates and provisioning profiles
4. App Store Connect API key

## Setup Steps

### 1. Create App in App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click "My Apps" → "+" → "New App"
3. Fill in:
   - Platform: iOS
   - Name: MultitouchArt
   - Primary Language: English
   - Bundle ID: `com.multitouchart.app` (or your custom ID)
   - SKU: `multitouchart-001`

### 2. Export Signing Certificate

On your Mac with Xcode installed:

```bash
# Export your distribution certificate
# In Keychain Access:
# 1. Find "Apple Distribution: Your Name"
# 2. Right-click → Export
# 3. Save as .p12 with a password
# 4. Convert to base64:
base64 -i YourCertificate.p12 | pbcopy
```

### 3. Export Provisioning Profile

```bash
# Download from Apple Developer portal or export from Xcode
# Convert to base64:
base64 -i YourProfile.mobileprovision | pbcopy
```

### 4. Create ExportOptions.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>uploadSymbols</key>
    <true/>
    <key>compileBitcode</key>
    <false/>
</dict>
</plist>
```

Convert to base64:
```bash
base64 -i ExportOptions.plist | pbcopy
```

### 5. Create App Store Connect API Key

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Users and Access → Keys → App Store Connect API
3. Click "+" to create a new key
4. Give it a name and "Admin" access
5. Download the `.p8` file (save it securely!)
6. Note the Key ID and Issuer ID

### 6. Add GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:

- `BUILD_CERTIFICATE_BASE64`: Your certificate .p12 in base64
- `P12_PASSWORD`: Password for the .p12 file
- `KEYCHAIN_PASSWORD`: A strong password for the temporary keychain (make one up)
- `PROVISIONING_PROFILE_BASE64`: Your provisioning profile in base64
- `EXPORT_OPTIONS_PLIST`: Your ExportOptions.plist in base64
- `APP_STORE_CONNECT_API_KEY`: Content of the .p8 API key file
- `APP_STORE_CONNECT_ISSUER_ID`: Issuer ID from App Store Connect

### 7. Trigger the Workflow

The workflow will run automatically when you push to the `cursor/multitouch-ios-app-5820` branch, or you can trigger it manually:

1. Go to Actions tab in GitHub
2. Select "iOS Build and TestFlight Deploy"
3. Click "Run workflow"

## Alternative: Local Build

If you prefer to build locally on your Mac:

```bash
# Clone the repo
git clone https://github.com/ricburton/Alot.git
cd Alot
git checkout cursor/multitouch-ios-app-5820

# Open in Xcode
open MultitouchArt/MultitouchArt.xcodeproj

# Then in Xcode:
# 1. Select your team in Signing & Capabilities
# 2. Product → Archive
# 3. Distribute to App Store Connect
```

## Troubleshooting

### Certificate Issues
- Make sure your certificate is valid and not expired
- Check that the bundle ID matches your provisioning profile

### Build Failures
- Check the Actions logs for detailed error messages
- Verify all secrets are correctly encoded in base64
- Ensure your Apple Developer account is in good standing

### TestFlight Upload Issues
- Verify your App Store Connect API key has proper permissions
- Check that the app version/build number is incremented
- Ensure you've accepted any updated agreements in App Store Connect

## Testing

Once uploaded to TestFlight:
1. Go to App Store Connect → TestFlight
2. The build will appear after processing (10-30 minutes)
3. Add internal testers (no review needed)
4. Add external testers (requires App Review)
5. Testers receive invitation emails
6. They install via TestFlight app

## Resources

- [App Store Connect](https://appstoreconnect.apple.com)
- [Apple Developer Portal](https://developer.apple.com)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Xcode Cloud Alternative](https://developer.apple.com/xcode-cloud/)
