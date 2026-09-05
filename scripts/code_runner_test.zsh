#!/usr/bin/env zsh

set -u

runner="${0:A:h}/code_runner.zsh"
tmp_dir=$(mktemp -d)
trap 'rm -rf -- "$tmp_dir"' EXIT

cat > "$tmp_dir/nonzero.c" <<'EOF'
int main(void) { return 23; }
EOF

cat > "$tmp_dir/nonzero.rs" <<'EOF'
fn main() { std::process::exit(42); }
EOF

failures=0
for file expected in "$tmp_dir/nonzero.c" 23 "$tmp_dir/nonzero.rs" 42; do
    NO_COLOR=1 zsh "$runner" "$file" >/dev/null
    actual=$?
    if (( actual != expected )); then
        print -u2 -- "FAIL: ${file:t} returned $actual, expected $expected"
        (( failures++ ))
    else
        print -- "PASS: ${file:t} returned $actual"
    fi
done

(( failures == 0 ))
