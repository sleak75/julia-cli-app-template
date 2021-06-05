# Julia ArgParse Template

A pattern I often want to use is is a command-line app whose functionality
is provided by subcommands, that can gather config by reading, in order:

1. `.toml` or whatever files in one or more locations
2. Environment variables
3. Command-line arguments

The actual commands, options, locations, etc are app-dependent, so this is 
a template to copy and modify rather than a package to call.
