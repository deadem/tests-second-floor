load utils/startup.bash

@test "Check npm run test existence" {
    [[ "$(npm run)" =~ (test) ]] # `npm run test` missed
}

@test "Run npm test" {
    run npm test
    [ "$status" -eq 0 ] || fatal "$output" # Lint js
}
