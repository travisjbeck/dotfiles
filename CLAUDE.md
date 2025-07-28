# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS development environment configuration managed with GNU Stow.

## Architecture

### Directory Structure Convention
Each application follows the pattern `<app>/.config/<app>/` mirroring actual config locations in `~/.config/`. Key components:

- **nvim/**: Neovim configuration using LazyVim framework with Lazy.nvim plugin manager
- **zsh/**: Z shell with Oh My Zsh, custom plugins, and Wezterm integration  
- **wezterm/**: Terminal emulator with modular Lua configuration
- **aerospace/**: macOS tiling window manager with custom shell scripts
- **karabiner/**: Keyboard remapping with complex modifications
- **git/**, **tmux/**, **sqlite/**: Standard configuration files

### GNU Stow Management
Dotfiles are managed using GNU Stow, which creates symlinks from the dotfiles directory to target locations:
- Each application directory (nvim/, zsh/, etc.) is a Stow package
- Run `stow <package>` from the dotfiles directory to symlink that package
- Run `stow -D <package>` to remove symlinks for that package
- Run `stow -R <package>` to restow (remove and re-add) a package

## Configuration Patterns

### Neovim Setup
- **LazyVim** base framework with extensive plugin ecosystem
- **Tokyo Night** colorscheme consistently used across tools
- **Claude Code plugin** integrated via `nvim/.config/nvim/lua/plugins/claude.lua`

### Shell Environment  
- **Oh My Zsh** with agnoster theme
- Key plugins: git, zsh-syntax-highlighting, zsh-autocomplete, zsh-autosuggestions
- **FZF integration** for fuzzy finding

### Terminal Configuration
Multiple terminal options configured (Wezterm, Ghostty, Alacritty, Kitty) with:
- **MesloLGS Nerd Font** as primary font
- **Tokyo Night** theme consistency
- Modular configuration split across files

## Working with This Repository

### Making Configuration Changes
When editing configurations:
1. Edit files in their respective `<app>/` directories
2. Changes take effect immediately due to existing Stow symlinks
3. Test changes before committing

### Adding New Configurations
1. Create new directory following `<app>/.config/<app>/` pattern
2. Add configuration files
3. Run `stow <app>` to create symlinks

### Installation and Setup
Basic setup process:
1. Install GNU Stow: `brew install stow`
2. Clone repository to `~/.dotfiles`
3. Use `stow <package>` for each desired configuration package
4. Install dependencies (Oh My Zsh, plugins, fonts) as needed

## Important Notes

- **macOS-specific**: Configurations assume macOS environment
- **Development-focused**: Optimized for software development workflow
- **Claude AI integrated**: Neovim includes Claude Code plugin for AI assistance
- **GNU Stow managed**: Use Stow commands to manage symlinks rather than manual linking