#!/bin/bash

# Permanent fix for CocoaPods without sudo
# This creates a wrapper that ensures user gems are loaded first

echo "🔧 Creating permanent CocoaPods fix..."

# Create a pod wrapper script in user's local bin
USER_BIN="$HOME/.local/bin"
mkdir -p "$USER_BIN"

# Create a wrapper script that fixes the gem loading order
cat > "$USER_BIN/pod" << 'PODWRAPPER'
#!/usr/bin/env ruby
# CocoaPods wrapper that fixes gem loading issues

# Add user gem paths first (before system paths)
user_gem_path = File.expand_path("~/.gem/ruby/2.6.0")
if Dir.exist?(user_gem_path)
  # Add to GEM_PATH
  ENV['GEM_HOME'] = user_gem_path
  ENV['GEM_PATH'] = "#{user_gem_path}:#{ENV['GEM_PATH'] || '/Library/Ruby/Gems/2.6.0'}"
  
  # Add to LOAD_PATH before anything else
  $LOAD_PATH.unshift(File.join(user_gem_path, "gems", "logger-1.7.0", "lib")) if Dir.exist?(File.join(user_gem_path, "gems", "logger-1.7.0"))
  
  # Find and add logger gem path
  logger_gems = Dir.glob(File.join(user_gem_path, "gems", "logger-*", "lib"))
  logger_gems.each { |path| $LOAD_PATH.unshift(path) }
  
  # Force load logger before anything else
  begin
    require 'logger'
  rescue LoadError
    # Try to find logger in any gem directory
    Dir.glob(File.join(user_gem_path, "gems", "logger-*", "lib", "*.rb")).each do |file|
      require file
    end
  end
end

# Now load the actual CocoaPods
begin
  # Try user-installed CocoaPods first
  load File.join(user_gem_path, "gems", "cocoapods-1.16.2", "bin", "pod")
rescue LoadError
  # Fall back to system CocoaPods
  load Gem.bin_path('cocoapods', 'pod', '>= 0.a')
end
PODWRAPPER

chmod +x "$USER_BIN/pod"

# Add to PATH in shell profile
SHELL_PROFILE=""
if [ -f "$HOME/.zshrc" ]; then
  SHELL_PROFILE="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then
  SHELL_PROFILE="$HOME/.bash_profile"
elif [ -f "$HOME/.profile" ]; then
  SHELL_PROFILE="$HOME/.profile"
fi

if [ -n "$SHELL_PROFILE" ]; then
  if ! grep -q "$USER_BIN" "$SHELL_PROFILE"; then
    echo "" >> "$SHELL_PROFILE"
    echo "# CocoaPods fix - add user bin to PATH" >> "$SHELL_PROFILE"
    echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$SHELL_PROFILE"
    echo "✅ Added PATH to $SHELL_PROFILE"
  fi
fi

# Export for current session
export PATH="$USER_BIN:$PATH"

echo "✅ CocoaPods wrapper created at $USER_BIN/pod"
echo ""
echo "To use it in this session, run:"
echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
echo ""
echo "Or restart your terminal. Then try:"
echo "  pod --version"
echo "  cd ios && pod install"

