setup_file() {
    echo "" #init
}

teardown_file() {
    load utils/processes.bash
    kill_descendant_processes "$(< "${BATS_RUN_TMPDIR}/node.pid")"
}

setup() {
    [ ! -f ${BATS_PARENT_TMPNAME}.skip ] || skip "skip remaining tests"
}

teardown() {
    [ -n "$BATS_TEST_COMPLETED" ] || touch ${BATS_PARENT_TMPNAME}.skip
}

@test "Check node_modules in .gitignore" {
    [[ "$(cat .gitignore)" =~ (node_modules) ]]
}

@test "Check npm run start existence" {
    [[ "$(npm run)" =~ (start) ]]
}

@test "Check Vite/Parcel presence" {
    [[ "$(cat package.json)" =~ ("vite"|"parcel") ]]
}

@test "Run npm install" {
    run npm install
    [ "$status" -eq 0 ]
}

@test "Run npm run start" {
    npm run start 2>&1 >/dev/null &
    echo "$!" > "${BATS_RUN_TMPDIR}/node.pid"
}

@test "Check port 3000" {
    timeout 600 bash "${BATS_TEST_DIRNAME}/utils/wait_for_port_3000.bash"
}
