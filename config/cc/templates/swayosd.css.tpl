/* Rendered by cc-theme-set from ~/.config/cc/templates/swayosd.css.tpl */
@define-color background-color {{ background }};
@define-color border-color     {{ accent }};
@define-color label            {{ foreground }};
@define-color image            {{ foreground }};
@define-color progress         {{ accent }};

window {
    background-color: transparent;
    border: none;
    padding: 0;
}

.osd,
osd {
    background-color: alpha(@background-color, 0.92);
    border: 2px solid @border-color;
    padding: 10px 16px;
}

image {
    color: @image;
    margin: 0 12px 0 0;
}

label {
    color: @label;
    font-family: "JetBrainsMono Nerd Font";
    font-weight: bold;
}

progressbar {
    min-height: 6px;
    min-width: 200px;
}

progressbar trough {
    background: alpha(@label, 0.2);
    min-height: 6px;
}

progressbar progress {
    background: @progress;
    min-height: 6px;
}
