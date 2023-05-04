load utils/startup.bash

@test "Check typescript in devDependencies" {
    run jq <package.json "(.dependencies.typescript | length)"
    [ "$output" -eq 0 ] || fatal "$(cat package.json)" # Typescript should be only in devDependencies, not in dependencies

    run jq <package.json "(.devDependencies.typescript | length)"
    [ "$output" -ne 0 ] || fatal "$(cat package.json)" # No typescript in package.json
}
