@test "Check dist and node_modules in .gitignore" {
}

@test "Check npm run start existence" {
    [[ "$(npm run)" =~ 'start' ]]
}
