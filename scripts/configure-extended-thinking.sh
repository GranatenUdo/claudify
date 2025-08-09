#!/bin/bash
# Configure Extended Thinking for Claude Code (Project-Level)
# Replaces the deprecated max_thinking_tokens YAML field

echo "🧠 CLAUDE CODE EXTENDED THINKING CONFIGURATION"
echo "=============================================="
echo ""
echo "This script configures MAX_THINKING_TOKENS for your project."
echo "Settings will be saved to .claude/settings.json (team) or .claude/settings.local.json (personal)"
echo ""

# Check if .claude directory exists
if [ ! -d ".claude" ]; then
    echo "❌ Error: .claude directory not found!"
    echo "Please run this from your project root where .claude exists."
    exit 1
fi

# Show current configuration if exists
if [ -f ".claude/settings.json" ]; then
    current_tokens=$(grep -o '"MAX_THINKING_TOKENS":\s*"[0-9]*"' .claude/settings.json | grep -o '[0-9]*' || echo "not set")
    echo "📊 Current project setting: MAX_THINKING_TOKENS = $current_tokens"
fi

if [ -f ".claude/settings.local.json" ]; then
    local_tokens=$(grep -o '"MAX_THINKING_TOKENS":\s*"[0-9]*"' .claude/settings.local.json | grep -o '[0-9]*' || echo "not set")
    echo "📊 Current personal setting: MAX_THINKING_TOKENS = $local_tokens"
fi

echo ""
echo "🎯 TOKEN LIMITS GUIDE:"
echo "  • Minimum:      1,024 tokens"
echo "  • Standard:     32,000 tokens (good for most tasks)"
echo "  • Recommended:  49,152 tokens (Opus 4 optimization) ✨"
echo "  • High:         65,536 tokens (complex reasoning)"
echo "  • Maximum:      100,000 tokens (intensive analysis)"
echo "  • Extreme:      200,000 tokens (theoretical max, may be unstable)"
echo ""
echo "⚠️  Note: Values above 32K may require batch processing for stability"
echo ""

# Ask user for configuration choice
echo "Choose configuration level:"
echo "  1) Team/Project (shared via git) - .claude/settings.json"
echo "  2) Personal (local only) - .claude/settings.local.json"
echo "  3) Both"
echo ""
read -p "Enter choice (1-3): " config_choice

# Ask for token value
echo ""
echo "Choose thinking token budget:"
echo "  1) Standard (32,000)"
echo "  2) Recommended (49,152) ✨"
echo "  3) High (65,536)"
echo "  4) Maximum (100,000)"
echo "  5) Custom value"
echo ""
read -p "Enter choice (1-5): " token_choice

# Set token value based on choice
case $token_choice in
    1) tokens="32000" ;;
    2) tokens="49152" ;;
    3) tokens="65536" ;;
    4) tokens="100000" ;;
    5) 
        read -p "Enter custom token value (1024-200000): " tokens
        if [ "$tokens" -lt 1024 ] || [ "$tokens" -gt 200000 ]; then
            echo "❌ Invalid value. Must be between 1024 and 200000."
            exit 1
        fi
        ;;
    *) 
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

# Function to update or create settings file
update_settings() {
    local file=$1
    local backup_file="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    if [ -f "$file" ]; then
        # Backup existing file
        cp "$file" "$backup_file"
        echo "📦 Backed up existing file to: $backup_file"
        
        # Check if MAX_THINKING_TOKENS already exists
        if grep -q '"MAX_THINKING_TOKENS"' "$file"; then
            # Update existing value
            sed -i.tmp 's/"MAX_THINKING_TOKENS":\s*"[0-9]*"/"MAX_THINKING_TOKENS": "'$tokens'"/' "$file"
            rm -f "${file}.tmp"
            echo "✅ Updated MAX_THINKING_TOKENS to $tokens in $file"
        else
            # Add to env section
            if grep -q '"env"' "$file"; then
                # Add to existing env section
                sed -i.tmp '/"env":\s*{/a\    "MAX_THINKING_TOKENS": "'$tokens'",' "$file"
                rm -f "${file}.tmp"
                echo "✅ Added MAX_THINKING_TOKENS = $tokens to $file"
            else
                # Create new env section
                echo "⚠️  No env section found. Creating minimal settings file..."
                cat > "$file" << EOF
{
  "env": {
    "MAX_THINKING_TOKENS": "$tokens",
    "ANTHROPIC_CUSTOM_HEADERS": "anthropic-beta: interleaved-thinking-2025-05-14"
  },
  "model": "opus",
  "description": "Extended thinking configuration"
}
EOF
                echo "✅ Created new settings file with MAX_THINKING_TOKENS = $tokens"
            fi
        fi
    else
        # Create new file
        cat > "$file" << EOF
{
  "env": {
    "MAX_THINKING_TOKENS": "$tokens",
    "ANTHROPIC_CUSTOM_HEADERS": "anthropic-beta: interleaved-thinking-2025-05-14"
  },
  "model": "opus",
  "description": "Extended thinking configuration"
}
EOF
        echo "✅ Created $file with MAX_THINKING_TOKENS = $tokens"
    fi
}

# Apply configuration based on choice
case $config_choice in
    1)
        update_settings ".claude/settings.json"
        ;;
    2)
        update_settings ".claude/settings.local.json"
        # Add to .gitignore if not already there
        if [ -f ".gitignore" ] && ! grep -q "settings.local.json" .gitignore; then
            echo ".claude/settings.local.json" >> .gitignore
            echo "📝 Added settings.local.json to .gitignore"
        fi
        ;;
    3)
        update_settings ".claude/settings.json"
        update_settings ".claude/settings.local.json"
        # Add to .gitignore if not already there
        if [ -f ".gitignore" ] && ! grep -q "settings.local.json" .gitignore; then
            echo ".claude/settings.local.json" >> .gitignore
            echo "📝 Added settings.local.json to .gitignore"
        fi
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "🎉 Configuration complete!"
echo ""
echo "💡 NEXT STEPS:"
echo "  1. Restart Claude Code for settings to take effect"
echo "  2. Test with: claude code"
echo "  3. Your agents will now use extended thinking with $tokens tokens"
echo ""
echo "📚 Additional Options (edit settings file directly):"
echo "  • CLAUDE_CODE_MAX_OUTPUT_TOKENS: \"64000\" (for longer outputs)"
echo "  • model: \"opus\" or \"sonnet\" or \"haiku\""
echo ""
echo "✨ Extended thinking is now configured for your project!"