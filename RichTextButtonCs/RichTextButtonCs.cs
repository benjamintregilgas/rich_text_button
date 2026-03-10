using Godot;

/// <summary>A button type with additional rich text functionality.</summary>
[GlobalClass, Tool, Icon("RichTextButton.svg")]
public partial class RichTextButtonCs : BaseButton
{
    private const string Classname = "RichTextButton";

    private bool _bbcodeEnabled;
    /// <summary>Enables the buttons text using BBCode formatting.<br />
    /// Note: This only affects the contents of [member text], not the tag stack.</summary>
    [Export]
    public bool BbCodeEnabled
    {
        get => _bbcodeEnabled;
        set
        {
            _bbcodeEnabled = value;
            if (_rtl is not null)
            {
                _rtl.BbcodeEnabled = value;
            }

            UpdateRtl();
        }
    }
    
    private string _richText = "";
    /// <summary>The button's text that will be displayed inside the button's area.</summary>
    [Export(PropertyHint.MultilineText)]
    public string RichText
    {
        get => _richText;
        set
        {
            _richText = value;
            if (_rtl is not null)
            {
                _rtl.Text = RichText;
            }

            UpdateRtl();
        }
    }

    private bool _displayAsFlat;
    /// <summary>Flat buttons don't display decoration.</summary>
    [Export]
    public bool DisplayAsFlat
    {
        get => _displayAsFlat;
        set
        {
            _displayAsFlat = value;
            QueueRedraw();
        }
    }

    private RichTextLabel _rtl;

    public RichTextButtonCs()
    {
        Theme ??= ResourceLoader.Load<Theme>(
            $"{GetScript().As<CSharpScript>().ResourcePath.GetBaseDir()}/rich_text_button_theme.tres"
            );

        foreach (var node in GetChildren())
        {
            if (node is RichTextLabel)
            { RemoveChild(node); }
        }

        InitRtl();
        UpdateRtl();

        return;
        void InitRtl()
        {
            if (_rtl is not null)
            { return; }
            
            _rtl = new RichTextLabel();
            _rtl.Size = Vector2.Zero;
            _rtl.BbcodeEnabled = BbCodeEnabled;
            _rtl.FitContent = true;
            _rtl.AutowrapMode = TextServer.AutowrapMode.Off;
            _rtl.VerticalAlignment = VerticalAlignment.Center;
            _rtl.HorizontalAlignment = HorizontalAlignment.Center;
            _rtl.MouseFilter = MouseFilterEnum.Ignore;
            
            AddChild(_rtl);
        }
    }
    
    private void UpdateRtl()
    {
        if (_rtl is null)
        { return; }
        
        _rtl.SetAnchorsAndOffsetsPreset(LayoutPreset.FullRect);
        UpdateRtlTheme();
        UpdateMinimumSize();

        void UpdateRtlTheme()
        {
            // Font
            var font = GetThemeFont("font", Classname);
            var size = GetThemeFontSize("font_size", Classname);
            if (font is not null)
            { _rtl.AddThemeFontOverride("normal_font", font); }

            if (size > 0)
            { _rtl.AddThemeFontSizeOverride("normal_font_size", size); }

            // Color
            var color = Colors.White;
            if (Disabled && HasThemeColor("font_disabled_color", Classname))
            { color = GetThemeColor("font_disabled_color", Classname); }
            
            else if (IsPressed() && HasThemeColor("font_pressed_color", Classname))
            { color = GetThemeColor("font_pressed_color", Classname); }
            
            else if (IsHovered())
            {
                if (IsPressed() && HasThemeColor("font_hover_pressed", Classname))
                { color = GetThemeColor("font_hover_pressed", Classname); }
                
                else if (HasThemeColor("font_hover", Classname))
                { color = GetThemeColor("font_hover", Classname); }
            }
            
            else if (HasFocus() && HasThemeColor("font_focus_color", Classname))
            { color = GetThemeColor("font_focus_color", Classname); }
            
            else if (HasThemeColor("font_color", Classname))
            { color = GetThemeColor("font_color", Classname); }

            _rtl.AddThemeColorOverride("default_color", color);

            // Outline
            var outlineSize = GetThemeConstant("outline_size", Classname);
            var outlineColor = GetThemeColor("font_outline_color", Classname);
            if (outlineSize is not 0)
            { _rtl.AddThemeConstantOverride("outline_size", outlineSize); }
            
            if (outlineColor != new Color(0,0,0,0))
            { _rtl.AddThemeColorOverride("font_outline_color", outlineColor); }
        }
    }

    public override void _Draw()
    {
        UpdateRtl();
        
        if (!DisplayAsFlat)
        {
            var stylebox = GetCurrentStylebox();
            stylebox?.Draw(GetCanvasItem(), new Rect2(Vector2.Zero, Size));
        }

        if (HasFocus())
        {
            GetThemeStylebox("focus", Classname).Draw(GetCanvasItem(), new Rect2(Vector2.Zero, Size));
        }
        
        base._Draw();
    }

    public override Vector2 _GetMinimumSize()
    {
        var size = Vector2.Zero;
        if (_rtl is null)
        { return size; }

        size = _rtl.GetCombinedMinimumSize();
        var stylebox = GetCurrentStylebox();
        if (stylebox is not null)
        {
            size.X += stylebox.ContentMarginLeft + stylebox.ContentMarginRight;
            size.Y += stylebox.ContentMarginTop + stylebox.ContentMarginBottom;
        }

        return size;
    }

    private StyleBox GetCurrentStylebox()
    {
        if (Disabled && HasThemeStylebox("disabled", Classname))
        { return GetThemeStylebox("disabled", Classname); }
        
        if (IsPressed() && HasThemeStylebox("pressed", Classname))
        { return GetThemeStylebox("pressed", Classname); }
        
        if (IsHovered())
        {
            if (IsPressed() && HasThemeStylebox("hover_pressed", Classname))
            { return GetThemeStylebox("hover_pressed", Classname); }
            
            if (HasThemeStylebox("hover", Classname))
            { return GetThemeStylebox("hover", Classname); }
        }
        
        else if (HasThemeStylebox("normal", Classname))
        { return GetThemeStylebox("normal", Classname); }
        
        return null;
    }
}