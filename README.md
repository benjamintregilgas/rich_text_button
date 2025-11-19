# RichTextButton

RichTextButton is a Godot 4 custom node class, extending BaseButton, which replicates Button functionality whilst also providing support for BBCode.

This makes it ideal for UI elements which require stylised and/or visually enhanced text.

## Getting Started

To copy over the custom node and example projects, copy everything inside the `rich_text_button/` folder in this repository.

To copy over just the custom node, copy everything inside `rich_text_button/` folder excluding the `rich_text_button/example/` folder.

## Usage

### Adding Node to Scene Tree from the Godot Editor

After copying the custom class:

1. In the Scene tab, add a child node (default shortcut: Ctrl+A).
2. Search for "RichTextButton". The project comes with a custom icon to differentiate it from other nodes.

### Creating Node from Code

```gdscript
func _ready() -> void:
    var rtb = RichTextButton.new()
    rtb.text = "Click the [b]Bold[/b] text!"
    rtb.pressed.connect(_rtb_pressed)
    add_child(rtb)

func _rtb_pressed() -> void:
    print("You clicked the bold text!")
```

### Theming

RichTextButton loads its default theme from the same folder as the script. This custom theme supports RichTextButton's styles.

To customise the theme:

1. In the Inspector after highlighting a RichTextButton node, navigate to the `theme_resource` property (Theme Resource), access the drop down, and make it unique.
2. Modify RichTextButton's styles including font colours, font and font size, and style boxes.
3. Changes will now persist when running the project.

You may also wish to assign a completely separate theme:

```gdscript
var rtb = RichTextButton.new()
rtb.theme_resource = load("res://custom_richtextbutton_theme.tres")
```

### Supported BBCode

RichTextButton supports a subset of RichTextLabel BBCode features, due to implementation details.

- **Styles**: bold, italic, underline, strikethrough.
- **Colours**: text colour, foreground colour, background colour.
- **Images**: [img]
- **Alignment**: left, center, right.
- **Effects**: pulse, wave, tornado, shake, rainbow.
- **Tables**: [table], [cell].

Note: Because underlying implementation involves a RichTextLabel with `mouse_filter = Control.MOUSE_FILTER_IGNORE`, features such as links and tooltips will not work.

## Roadmap

There are no currently planned features.

See the [Contribution](#contributing) section if you'd like to see any new features or improvements added.

## Contributing

As an advocate for open-source development, this prokect is fully available on GitHub - including implementation details for learning and/or modification.

Contributions are **greately appreciated**, due to this project being maintained in limited spare time.

If you have a suggestion that would make this custom node better, please fork the repository and create a pull request. You can also simply open an issue with the tag "enhancement".

## License

Distributed under the MIT license. See <code>LICENSE</code> for more information.

## Contact

Project Link: https://github.com/benjamintregilgas/rich_text_button

## Acknowledgements

This project was developed using the following tools:

- [Godot v4.5 Documentation](https://docs.godotengine.org/en/stable/) - For miscellaneous information regarding themes, BaseButton, and documentation comments.
- [Inkscape](https://github.com/inkscape/inkscape?tab=readme-ov-file) - For creating the Editor Node Icon
