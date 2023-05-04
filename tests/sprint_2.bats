load utils/startup.bash

@test "Check typescript in devDependencies" {
    run jq <package.json "(.dependencies.typescript | length)"
    [ "$output" -eq 0 ] || fatal "$(cat package.json)" # Typescript should be only in devDependencies, not in dependencies

    run jq <package.json "(.devDependencies.typescript | length)"
    [ "$output" -ne 0 ] || fatal "$(cat package.json)" # No typescript in package.json
}

@test "Check tsconfig" {
    if [ ! -f "./tsconfig.json" ]; then
        fatal "tsconfig.json required" # tsconfig.json not found in project directory
    fi

    run jq <tsconfig.json "(.compilerOptions.noImplicitAny | contains(true))"
    [ "$output" == "true" ] || fatal "$output" "$(cat tsconfig.json)" # Check "noImplicitAny": true option in tsconfig.json

    run jq <tsconfig.json "(.compilerOptions.noUnusedLocals | contains(true))"
    [ "$output" == "true" ] || fatal "$output" "$(cat tsconfig.json)" # Check "noUnusedLocals": true option in tsconfig.json

    run jq <tsconfig.json "(.compilerOptions.noUnusedParameters | contains(true))"
    [ "$output" == "true" ] || fatal "$output" "$(cat tsconfig.json)" # Check "noUnusedParameters": true option in tsconfig.json

    run jq <tsconfig.json "(.compilerOptions.sourceMap | contains(true))"
    [ "$output" == "true" ] || fatal "$output" "$(cat tsconfig.json)" # Check "sourceMap": true option in tsconfig.json

    run jq <tsconfig.json "(.compilerOptions.strictNullChecks | contains(true))"
    [ "$output" == "true" ] || fatal "$output" "$(cat tsconfig.json)" # Check "strictNullChecks": true option in tsconfig.json
}
