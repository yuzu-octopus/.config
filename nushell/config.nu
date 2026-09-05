alias cls = clear
alias edit = micro
alias nano = micro
alias py = python3
alias quit = exit
alias whatsapp = nchat
alias pi = omp

$env.config = ($env.config
| upsert show_banner false
| upsert edit_mode emacs
| upsert buffer_editor "micro"
| upsert rm { always_trash: true }
| upsert history {
    file_format: sqlite
    max_size: 5_000_000
    sync_on_enter: true
    isolation: true
}
| upsert completions {
    case_sensitive: false
    algorithm: "fuzzy"
    partial: true
    quick: true
})

# Load theme (ignore errors if file doesn't exist)
try { source ~/.config/nushell/themes/dracula.nu } catch { }

if $nu.is-interactive and ($env.TERM_PROGRAM != "zed") {
    clear
    ^fastfetch
}

# Helper: generate init script if missing or outdated
let init = {|file, cmd|
    try {
        if ($file | path exists) {
            let current = (do $cmd)
            let saved = (open $file)
            if $current == $saved { return }
        }
        do $cmd | save -f $file
    } catch { }
}

do $init ($nu.data-dir | path join "vendor/autoload/starship.nu") { starship init nu }
do $init ($nu.data-dir | path join "vendor/autoload/zoxide.nu") { zoxide init nushell }
do $init ($nu.data-dir | path join "vendor/autoload/carapace.nu") { carapace _carapace nushell }
do $init ($nu.data-dir | path join "vendor/autoload/uv.nu") { uv generate-shell-completion nushell }
