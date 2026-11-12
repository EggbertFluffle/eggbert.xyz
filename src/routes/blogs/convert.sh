#! /bin/bash

# Pandoc emits empty line-anchor links in highlighted code blocks. They are
# hidden from assistive technology and trigger Svelte's a11y warnings, so strip
# them while keeping the syntax highlighting.
pandoc *.md \
	| sed 's/{/{"{"}/g' \
	| sed -E 's|<a href="#cb[0-9]+-[0-9]+" aria-hidden="true" tabindex="-1"></a>||g' \
	> +page.svelte

echo "Don't forget to add alt properties to <img> tags"
echo "Don't forget to add alt properties to <img> tags"
echo "Don't forget to add alt properties to <img> tags"
echo "Don't forget to add alt properties to <img> tags"
echo "Don't forget to add alt properties to <img> tags"
echo "Don't forget to add alt properties to <img> tags"
