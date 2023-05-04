load utils/tests.bats

setup_file() {
    echo "" #init
}

teardown_file() {
    shutdown_node
}

setup() {
    [ ! -f ${BATS_PARENT_TMPNAME}.skip ] || skip "skip remaining tests"
}

teardown() {
    [ -n "$BATS_TEST_COMPLETED" ] || touch ${BATS_PARENT_TMPNAME}.skip
}

@test "Check node_modules in .gitignore" {
    [[ "$(cat .gitignore)" =~ (node_modules) ]] # node_modules should be gitignored
}

@test "Check dist|build in .gitignore" {
    [[ "$(cat .gitignore)" =~ (dist|build) ]] # dist|build directory should be gitignored
}

@test "Check npm run start existence" {
    [[ "$(npm run)" =~ (start) ]] # `npm run start` missed
}

@test "Check Vite/Parcel presence" {
    run jq <package.json "(.devDependencies.parcel | length) + (.devDependencies.vite | length)"
    [ "$output" -ne "0" ] || fatal "$(cat package.json)" # No Parcel or Vite found in devDependencies section of package.json
}

@test "Check newline at end of files" {
    for FILE in $(\
        find . -mindepth 1 -type f -regextype posix-extended \
        -regex ".*\.(js|ts|txt|md|html|css|scss|sass|styl|less|pcss|json)" \
        ! -path "*/.*" \
        ! -path '*/node_modules/*' \
    ); do

        if ! [[ -s "$FILE" && -z "$(tail -c 1 "$FILE")" ]]
        then
            echo "No newline at end of file $FILE"
            echo "Each line should be terminated in a newline character, including the last one."
            echo "https://stackoverflow.com/questions/5813311/whats-the-significance-of-the-no-newline-at-end-of-file-log"
            exit 1
        fi
    done
}

@test "Netlify link in README.md" {
    [[ "$(cat *.md)" =~ ([Nn]etlify\.app|onrender\.com) ]] # No netlify.app or onrender.com link found
}

@test "Check NodeJS version" {
    if test -f ".nvmrc"; then
        run cat .nvmrc
    else
        run jq <package.json "(.engines.node)"
        [[ "$output" = "null" ]] && fatal "$output" # Can't find "node" in "engines" section in package.json
    fi
    [[ "$output" =~ ([0-9]+) ]] || fatal "$output" # Invalid Node version
    (( "${BASH_REMATCH[1]}" >= 12 )) || fatal "Version: ${BASH_REMATCH[1]}" # Invalid minimal Node version
}

@test "Run npm install" {
    run npm install
    [ "$status" -eq 0 ] || fatal "$output"
}

@test "Run npm run start and wait for port 3000" {
    start_node
}

@test "Check routing" {
    run curl -I http://localhost:3000/
    [ "$status" -eq 0 ] || fatal "$output" # curl http://localhost:3000/ failed
    [[ "$output" =~ (HTTP[^ \t]*[ \t]200) ]] || fatal "$output" # curl http://localhost:3000/ response failed
}
