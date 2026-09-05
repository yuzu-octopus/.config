$env.EDITOR = "micro"
$env.MICRO_TRUECOLOR = "1"
$env.CLICOLOR = "1"
$env.COLORTERM = "truecolor"
$env.LS_COLORS = (try { vivid generate dracula } catch { "" })
$env.BUN_INSTALL = ($nu.home-dir | path join ".bun")
$env.ESCDELAY = "50"
$env.BAT_THEME = "Dracula"

# Load secrets from ~/.config/secrets.toml if it exists
let secrets_path = ($nu.home-dir | path join ".config" "secrets.toml")
if ($secrets_path | path exists) {
    open $secrets_path | load-env
}

# PATH is already a list after automatic conversion at startup
$env.PATH = (
    $env.PATH
    | prepend [
        ($nu.home-dir | path join ".local" "bin")
        ($nu.home-dir | path join ".bun" "bin")
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
        ($nu.home-dir | path join ".lmstudio" "bin")
        ($nu.home-dir | path join ".spicetify")
        ($nu.home-dir | path join ".orbstack" "bin")
        ($nu.home-dir | path join ".composio")
    ]
    | uniq
    | path expand
)

# Streamlined Zoxide Exclusions (Linux/macOS)
$env._ZO_EXCLUDE_DIRS = [
    # --- Dependencies & Envs ---
    "**/node_modules/*"      # Node.js
    "**/.venv/*"            # Python
    "**/venv/*"
    "**/vendor/*"           # Go / PHP / Ruby Dependencies
    "**/.pnpm-store/*"      # PNPM Cache
    "**/.direnv/*"

    # --- Language Build Outputs ---
    "**/target/*"           # Rust
    "**/.next/*"            # Next.js
    "**/.nuxt/*"            # Nuxt.js
    "**/dist/*"             # Vite / Webpack
    "**/build/*"            # Frontend / Native Builds
    "**/out/*"

    # --- Containers & Git ---
    "**/.docker/*"          # Docker Local Configs
    "**/.git/*"             # Git Internals

    # --- OS Temporary Directories ---
    "**/.Trash/*"           # macOS Trash
    "/tmp/*"                # Global Linux/macOS Temp Dir
] | str join (char esep)
