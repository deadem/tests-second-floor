load utils/startup.bash

@test "Check npm run test existence" {
    [[ "$(npm run)" =~ (test) ]] # `npm run test` missed
}
