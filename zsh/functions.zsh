bug() {
    [ -n "$1" ] && sh "$HOME/.dotfiles/scripts/openai.sh" \
        "I want you to write a bug report in the following format:
            description, steps to reproduce, expected result, actual result.
            Answer in markdown with the description, steps to reproduce,
            expected result and actual result headers in bold.
            Reference error report link if available.
            The input is: $1"
}

story() {
    [ -n "$1" ] && sh "$HOME/.dotfiles/scripts/openai.sh" \
        "I want you to write a user story in the following format:
            description, functional notes, acceptance criteria, test notes.
            Add to test notes to visually test in Storybook.
            Answer in markdown with the description, functional notes,
            acceptance criteria and test notes headers in bold and possible
            component names wrapped in backticks.
            The input is: $1"
}

ticket() {
    [ -n "$1" ] && sh "$HOME/.dotfiles/scripts/openai.sh" \
        "I want you to write a ticket in the following format:
            description, code snippet, test notes.
            Add to test notes to do a full regression test.
            Answer in markdown with the description, functional notes,
            acceptance criteria and test notes headers in bold and possible
            component names wrapped in backticks.
            The input is: $1"
}
