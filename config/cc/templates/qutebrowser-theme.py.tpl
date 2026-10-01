# Rendered by cc-theme-set from ~/.config/cc/templates/qutebrowser-theme.py.tpl.
# The qutebrowser hook copies it to ~/.config/qutebrowser/theme.py, which
# config.py sources last. Do not edit theme.py directly.
# pylint: disable=undefined-variable

bg = "{{ background }}"
bg_alt = "{{ dark_background }}"
bg_sel = "{{ selection_background }}"
fg = "{{ foreground }}"
fg_dim = "{{ muted }}"
fg_sel = "{{ selection_foreground }}"
accent = "{{ accent }}"
red = "{{ red }}"
green = "{{ green }}"
yellow = "{{ yellow }}"
blue = "{{ blue }}"
magenta = "{{ magenta }}"
cyan = "{{ cyan }}"

# Completion
c.colors.completion.fg = fg
c.colors.completion.odd.bg = bg_alt
c.colors.completion.even.bg = bg
c.colors.completion.category.fg = accent
c.colors.completion.category.bg = bg
c.colors.completion.category.border.top = bg
c.colors.completion.category.border.bottom = bg
c.colors.completion.item.selected.fg = fg_sel
c.colors.completion.item.selected.bg = bg_sel
c.colors.completion.item.selected.border.top = bg_sel
c.colors.completion.item.selected.border.bottom = bg_sel
c.colors.completion.item.selected.match.fg = accent
c.colors.completion.match.fg = accent
c.colors.completion.scrollbar.fg = fg
c.colors.completion.scrollbar.bg = bg

# Context menu
c.colors.contextmenu.menu.bg = bg
c.colors.contextmenu.menu.fg = fg
c.colors.contextmenu.selected.bg = bg_sel
c.colors.contextmenu.selected.fg = fg_sel
c.colors.contextmenu.disabled.bg = bg_alt
c.colors.contextmenu.disabled.fg = fg_dim

# Downloads
c.colors.downloads.bar.bg = bg
c.colors.downloads.start.fg = bg
c.colors.downloads.start.bg = blue
c.colors.downloads.stop.fg = bg
c.colors.downloads.stop.bg = green
c.colors.downloads.error.fg = red

# Hints
c.colors.hints.fg = bg
c.colors.hints.bg = accent
c.colors.hints.match.fg = fg
c.hints.border = "1px solid " + bg

# Keyhint
c.colors.keyhint.fg = fg
c.colors.keyhint.suffix.fg = accent
c.colors.keyhint.bg = bg

# Messages
c.colors.messages.error.fg = bg
c.colors.messages.error.bg = red
c.colors.messages.error.border = red
c.colors.messages.warning.fg = bg
c.colors.messages.warning.bg = yellow
c.colors.messages.warning.border = yellow
c.colors.messages.info.fg = fg
c.colors.messages.info.bg = bg
c.colors.messages.info.border = bg

# Prompts
c.colors.prompts.fg = fg
c.colors.prompts.bg = bg
c.colors.prompts.border = "1px solid " + accent
c.colors.prompts.selected.fg = fg_sel
c.colors.prompts.selected.bg = bg_sel

# Statusbar
c.colors.statusbar.normal.fg = fg
c.colors.statusbar.normal.bg = bg
c.colors.statusbar.insert.fg = bg
c.colors.statusbar.insert.bg = green
c.colors.statusbar.passthrough.fg = bg
c.colors.statusbar.passthrough.bg = blue
c.colors.statusbar.private.fg = bg
c.colors.statusbar.private.bg = magenta
c.colors.statusbar.command.fg = fg
c.colors.statusbar.command.bg = bg
c.colors.statusbar.command.private.fg = fg
c.colors.statusbar.command.private.bg = bg
c.colors.statusbar.caret.fg = bg
c.colors.statusbar.caret.bg = magenta
c.colors.statusbar.caret.selection.fg = bg
c.colors.statusbar.caret.selection.bg = cyan
c.colors.statusbar.progress.bg = accent
c.colors.statusbar.url.fg = fg
c.colors.statusbar.url.error.fg = red
c.colors.statusbar.url.hover.fg = cyan
c.colors.statusbar.url.success.http.fg = fg
c.colors.statusbar.url.success.https.fg = green
c.colors.statusbar.url.warn.fg = yellow

# Tabs
c.colors.tabs.bar.bg = bg_alt
c.colors.tabs.indicator.start = blue
c.colors.tabs.indicator.stop = green
c.colors.tabs.indicator.error = red
c.colors.tabs.odd.fg = fg_dim
c.colors.tabs.odd.bg = bg_alt
c.colors.tabs.even.fg = fg_dim
c.colors.tabs.even.bg = bg_alt
c.colors.tabs.selected.odd.fg = bg
c.colors.tabs.selected.odd.bg = accent
c.colors.tabs.selected.even.fg = bg
c.colors.tabs.selected.even.bg = accent
c.colors.tabs.pinned.odd.fg = fg
c.colors.tabs.pinned.odd.bg = bg
c.colors.tabs.pinned.even.fg = fg
c.colors.tabs.pinned.even.bg = bg
c.colors.tabs.pinned.selected.odd.fg = bg
c.colors.tabs.pinned.selected.odd.bg = accent
c.colors.tabs.pinned.selected.even.fg = bg
c.colors.tabs.pinned.selected.even.bg = accent

# Page background while loading, and qutebrowser's own pages
c.colors.webpage.bg = bg
