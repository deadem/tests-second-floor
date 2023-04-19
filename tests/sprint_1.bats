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

@test "Check npm run start existence" {
    [[ "$(npm run)" =~ (start) ]] # `npm run start` missed
}

@test "Check Vite/Parcel presence" {
    [[ "$(cat package.json)" =~ ("vite"|"parcel") ]] # No Parcel or Vite in package.json
}

@test "Netlify link in README.md" {
    [[ "$(cat *.md)" =~ ([Nn]etlify\.app|onrender\.com) ]] # No netlify.app or onrender.com link found
}

@test "Check NodeJS version" {
    if test -f ".nvmrc"; then
        run cat .nvmrc
        [[ "$output" =~ ([0-9]) ]] || fatal "$output" # Invalid Node version in .nvmrc
    else
        run cat package.json
        [[ "$output" =~ ("engines".*"node") ]] || fatal "$output" # Can't find "node" in "engines" section in package.json
    fi
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
