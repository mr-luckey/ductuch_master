#!/bin/bash

# Fix CocoaPods installation script
# This script will fix the broken CocoaPods installation

echo "🔧 Fixing CocoaPods installation..."

# Step 1: Install missing logger gem (required by ActiveSupport)
echo "📦 Installing logger gem..."
sudo gem install logger

# Step 2: Update ActiveSupport to fix the broken dependency
echo "📦 Updating ActiveSupport..."
sudo gem install activesupport -v 6.1.7.10

# Step 3: Uninstall broken CocoaPods
echo "🗑️  Removing broken CocoaPods installation..."
sudo gem uninstall cocoapods -x

# Step 4: Reinstall CocoaPods
echo "📦 Reinstalling CocoaPods..."
sudo gem install cocoapods

# Step 5: Setup CocoaPods
echo "⚙️  Setting up CocoaPods..."
pod setup

echo "✅ CocoaPods installation fixed!"
echo "You can now run 'pod install' in the ios directory."

