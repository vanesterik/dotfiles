ticket() {
    [ -n "$1" ] && sh "$HOME/.dotfiles/scripts/openai.sh" \
        "I want you to write a Jira ticket in the following format:
            description, functional notes, acceptance criteria, test notes. Add
            to test notes to functionally test with unit tests and visually
            test with Storybook stories. Answer in markdown with aforementioned
            topics in bold and possible component names wrapped in backticks.
            The input is: $1"
}
