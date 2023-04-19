setup_file() {
    echo "" #init
}

teardown_file() {
    load utils/processes.bash
    PID="$(< "${BATS_RUN_TMPDIR}/node.pid")"
    [ "${PID}" == "" ] || kill_descendant_processes "${PID}" true
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

@test "Run npm install" {
    run npm install
    [ "$status" -eq 0 ] || "$output" # `npm install` fails with errors
}

@test "Run npm run start" {
    npm run start 2>&1 >/dev/null & # Can't run `npm run start` 
    echo "$!" > "${BATS_RUN_TMPDIR}/node.pid"
}

@test "Check port 3000" {
    timeout 600 bash "${BATS_TEST_DIRNAME}/utils/wait_for_port_3000.bash" # `npm run start` doesn't run server on port 3000
}

@test "Check routing" {
    run curl -I http://localhost:3000/
    [ "$status" -eq 0 ] || "$output" # curl http://localhost:3000/ failed
    [[ "$output" =~ (HTTP[^ \t]*[ \t]200) ]] || "$output" # curl http://localhost:3000/ response failed
}
