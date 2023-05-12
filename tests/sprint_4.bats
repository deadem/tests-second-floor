load utils/startup.bash

@test "Check npm run test existence" {
    [[ "$(npm run)" =~ (test) ]] # Check presence of `npm run test`
}
