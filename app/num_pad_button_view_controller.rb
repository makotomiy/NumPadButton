class NumPadButtonViewController < UIViewController

  def viewDidLoad
    create_numField
    NSNotificationCenter.defaultCenter.addObserver(self,
                                          selector:'keyboard_did_show',
                                              name:UIKeyboardDidShowNotification,
                                            object:nil)
  end

  def dismiss_keyboard
    @numField.resignFirstResponder
  end

  def keyboard_did_show
    show_keyboard_button_for_text_field(@numField)
  end

  def show_keyboard_button_for_text_field(textField)
    # Remove previous button
    @doneButton.removeFromSuperview if @doneButton.respond_to?(:removeFromSuperview)
    @doneButton = nil

    # Look for keyboard
    UIApplication.sharedApplication.windows.each do |window|
      if window.class == UITextEffectsWindow
        window.subviews.each do |subview|
          if subview.class == UIPeripheralHostView
            @keyboard = subview
            break
          end
        end
        break
      end
    end

    # Add custom button
    if @keyboard and textField.keyboardType == UIKeyboardTypeNumberPad
      create_doneButton
    end
    @keyboard = nil
  end

  def create_numField
    @numField = UITextField.alloc.initWithFrame([[10,200], [300,40]])
    @numField.placeholder = "Some number here"
    @numField.keyboardType = UIKeyboardTypeNumberPad
    @numField.backgroundColor = UIColor.whiteColor
    view.addSubview(@numField)
  end

  def create_doneButton
    @doneButton = UIButton.buttonWithType(UIButtonTypeCustom)
    @doneButton.frame = [[0,163], [106,53]]
    @doneButton.adjustsImageWhenHighlighted = false
    @doneButton.titleLabel.font = UIFont.boldSystemFontOfSize(17)
    @doneButton.setTitle('Done', forState:UIControlStateNormal)
    # Color #4D5462
    color = UIColor.colorWithRed(0.302, green:0.329, blue:0.384, alpha:1.0)
    @doneButton.setTitleColor(color, forState:UIControlStateNormal)

    @doneButton.setBackgroundImage(UIImage.imageNamed("numberPadButton.png"), forState:UIControlStateHighlighted)
    @doneButton.setTitleColor(UIColor.whiteColor, forState:UIControlStateHighlighted)

    @doneButton.addTarget(self, action:'dismiss_keyboard', forControlEvents:UIControlEventTouchDown)
    @keyboard.addSubview(@doneButton)
  end

end