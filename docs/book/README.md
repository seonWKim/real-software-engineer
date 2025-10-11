# Real Engineer Project Documentation

This directory contains the mdBook-based documentation for the Real Engineer Project.

## Building the Book

### Prerequisites
```bash
# Install Rust and Cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install mdBook
cargo install mdbook

# Install mdbook-toc (table of contents preprocessor)
cargo install mdbook-toc
```

### Local Development
```bash
# Serve the book locally with auto-reload
mdbook serve

# Build the book
mdbook build

# Test the book
mdbook test
```

### GitHub Pages Deployment

The book is automatically deployed to GitHub Pages when changes are pushed to the `main` branch. The workflow is defined in `.github/workflows/mdbook.yml`.

## Structure

- `book.toml` - Configuration file
- `src/` - Markdown source files
- `custom.css` - Custom styling
- `theme/` - Custom theme files (if any)

## Contributing

1. Edit the markdown files in `src/`
2. Test locally with `mdbook serve`
3. Commit and push changes
4. GitHub Actions will automatically deploy to Pages

The book follows the same structure and style as the [mini-lsm book](https://skyzh.github.io/mini-lsm/).