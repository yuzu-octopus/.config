# Nushell Dracula Theme
# https://draculatheme.com

export def main [] {
    return {
        # --- Type colors ---
        binary: '#FFB86C'
        block: '#8BE9FD'
        cell-path: '#F8F8F2'
        closure: '#50FA7B'
        custom: '#F1FA8C'
        duration: '#50FA7B'
        float: '#FFB86C'
        glob: '#F8F8F2'
        int: '#FFB86C'
        list: '#50FA7B'
        nothing: '#FF79C6'
        range: '#50FA7B'
        record: '#50FA7B'
        string: '#F1FA8C'

        bool: {||
            if $in { '#50FA7B' } else { '#FFB86C' }
        }

        datetime: {||
            let age = (date now) - $in
            if $age < 1hr {
                { fg: '#FF79C6' attr: 'b' }
            } else if $age < 6hr {
                '#FF79C6'
            } else if $age < 1day {
                '#50FA7B'
            } else if $age < 3day {
                '#F1FA8C'
            } else if $age < 1wk {
                { fg: '#F1FA8C' attr: 'b' }
            } else if $age < 6wk {
                '#50FA7B'
            } else if $age < 52wk {
                '#8BE9FD'
            } else {
                '#6272A4'
            }
        }

        filesize: {|e|
            if $e == 0B {
                '#F8F8F2'
            } else if $e < 1MB {
                '#50FA7B'
            } else {
                '#8BE9FD'
            }
        }

        # --- Shape colors ---
        shape_and: { fg: '#FF79C6' attr: 'b' }
        shape_binary: { fg: '#FFB86C' attr: 'b' }
        shape_block: { fg: '#8BE9FD' attr: 'b' }
        shape_bool: '#FFB86C'
        shape_closure: { fg: '#50FA7B' attr: 'b' }
        shape_custom: '#F1FA8C'
        shape_datetime: { fg: '#50FA7B' attr: 'b' }
        shape_directory: '#50FA7B'
        shape_external: '#50FA7B'
        shape_external_resolved: '#50FA7B'
        shape_externalarg: { fg: '#F1FA8C' attr: 'b' }
        shape_filepath: '#50FA7B'
        shape_flag: { fg: '#8BE9FD' attr: 'b' }
        shape_float: { fg: '#FFB86C' attr: 'b' }
        shape_garbage: { fg: '#FFFFFF' bg: '#FF5555' attr: 'b' }
        shape_glob_interpolation: { fg: '#50FA7B' attr: 'b' }
        shape_globpattern: { fg: '#50FA7B' attr: 'b' }
        shape_int: { fg: '#FFB86C' attr: 'b' }
        shape_internalcall: { fg: '#50FA7B' attr: 'b' }
        shape_keyword: { fg: '#FF79C6' attr: 'b' }
        shape_list: { fg: '#50FA7B' attr: 'b' }
        shape_literal: '#8BE9FD'
        shape_match_pattern: '#F1FA8C'
        shape_matching_brackets: { attr: 'u' }
        shape_nothing: '#FF79C6'
        shape_operator: '#FF79C6'
        shape_or: { fg: '#FF79C6' attr: 'b' }
        shape_pipe: { fg: '#FF79C6' attr: 'b' }
        shape_range: { fg: '#50FA7B' attr: 'b' }
        shape_raw_string: { fg: '#F8F8F2' attr: 'b' }
        shape_record: { fg: '#50FA7B' attr: 'b' }
        shape_redirection: { fg: '#FF79C6' attr: 'b' }
        shape_signature: { fg: '#F1FA8C' attr: 'b' }
        shape_string: '#F1FA8C'
        shape_string_interpolation: { fg: '#50FA7B' attr: 'b' }
        shape_table: { fg: '#8BE9FD' attr: 'b' }
        shape_vardecl: { fg: '#8BE9FD' attr: 'u' }
        shape_variable: '#BD93F9'

        # --- UI elements ---
        foreground: '#F8F8F2'
        background: '#282A36'
        cursor: '#F8F8F2'

        empty: '#8BE9FD'
        header: { fg: '#F1FA8C' attr: 'b' }
        hints: '#6272A4'
        leading_trailing_space_bg: { attr: 'n' }
        row_index: { fg: '#F1FA8C' attr: 'b' }
        search_result: { fg: '#FF79C6' bg: '#44475A' }
        separator: '#6272A4'
    }
}

# Apply the color_config to Nushell
export def --env "set color_config" [] {
    $env.config.color_config = (main)
}

# Update terminal foreground/background/cursor via OSC sequences
export def "update terminal" [] {
    let theme = (main)

    print -n $"(ansi -o '10;')($theme.foreground)(char bel)"
    print -n $"(ansi -o '11;')($theme.background)(char bel)"
    print -n $"(ansi -o '12;')($theme.cursor)(char bel)"
}

# Activate both Nushell color_config and terminal colors
export def --env activate [] {
    set color_config
    update terminal
}

# When sourced, apply both
activate
