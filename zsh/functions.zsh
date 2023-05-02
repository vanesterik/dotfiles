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
