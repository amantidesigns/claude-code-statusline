# Contributing

Thank you for your interest in contributing to this project!

## Important Note

This is a fork of the original work by [@kanoliban](https://github.com/kanoliban). Please ensure:

1. **Attribution is maintained** - Keep references to the original author
2. **Test your changes** - Verify everything works before submitting
3. **Document new features** - Update README.md and EXAMPLES.md

## How to Contribute

### Report Bugs

Open an issue with:
- Description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Your environment (macOS version, terminal, etc.)

### Suggest Enhancements

Open an issue with:
- Clear description of the enhancement
- Why it would be useful
- Examples of how it would work

### Submit Pull Requests

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow existing code style
   - Test thoroughly
   - Update documentation

4. **Test the installation script**
   ```bash
   ./install.sh
   ```

5. **Test the statusline script manually**
   ```bash
   echo '{"model":{"display_name":"Sonnet 4.5"},"cost":{"total_cost_usd":1.23},"context_window":{"context_window_size":200000,"current_usage":{"input_tokens":10000,"cache_creation_input_tokens":5000,"cache_read_input_tokens":5000}},"workspace":{"current_dir":"~/test"}}' | ./statusline.sh
   ```

6. **Commit with clear messages**
   ```bash
   git commit -m "feat: add support for custom color themes"
   ```

7. **Push and create PR**
   ```bash
   git push origin feature/your-feature-name
   ```

## Code Guidelines

### Bash Script Style

- Use `set -e` for error handling
- Quote variables: `"$VARIABLE"`
- Comment complex logic
- Use meaningful variable names
- Prefer `$(command)` over backticks

### Documentation Style

- Use clear, concise language
- Include examples for new features
- Update all relevant docs (README, EXAMPLES, etc.)
- Use proper markdown formatting

## Testing Checklist

Before submitting a PR, verify:

- [ ] Installation script works on clean system
- [ ] Statusline script outputs correct format
- [ ] Works with and without CodexBar
- [ ] Works in git and non-git directories
- [ ] Error handling works properly
- [ ] Documentation is updated
- [ ] No broken links in docs
- [ ] Attribution to original author is maintained

## Questions?

Open an issue for any questions about contributing.

## Code of Conduct

- Be respectful and constructive
- Credit others' work appropriately
- Focus on improving the project
- Help newcomers learn

## Credits

Always remember to credit:
- [@kanoliban](https://github.com/kanoliban) - Original implementation
- [@steipete](https://github.com/steipete) - CodexBar
- All contributors to this fork
