//***************************************************************************
//* Written by Steve Chiu <steve.chiu@benq.com>
//* BenQ Corporation, All Rights Reserved.
//*
//* NOTICE: All information contained herein is, and remains the property
//* of BenQ Corporation and its suppliers, if any. Dissemination of this
//* information or reproduction of this material is strictly forbidden
//* unless prior written permission is obtained from BenQ Corporation.
//***************************************************************************

import UIKit

//---------------------------------------------------------------------------

public class PopoverMenu {
    public struct Options {
        public var font = UIFont.systemFontOfSize(19)
        public var minItemHeight: CGFloat = 44
        public var minItemWidth: CGFloat = 44
        public var marginX: CGFloat = 25
        public var marginY: CGFloat = 8
        public var iconGap: CGFloat = 10
        public var showSeparator = false
    }

    public class Item {
        public var title: String
        public var icon: UIImage?
        public var color: UIColor?
        public var alignment: NSTextAlignment
        public var checked: Bool
        public var handler: (() -> Void)?

        public var enabled: Bool {
            return self.handler != nil
        }
        
        public init(title: String, icon: UIImage? = nil, color: UIColor? = nil, alignment: NSTextAlignment = .Left, checked: Bool = false, handler: (() -> Void)? = nil) {
            self.title = title
            self.icon = icon
            self.color = color
            self.alignment = alignment
            self.checked = checked
            self.handler = handler
        }
    }

    public static var options = Options()
    public var options: Options?
    private var items = [Item]()

    public init(options: Options? = nil) {
        self.options = options
    }

    public func addItem(item: Item) -> PopoverMenu {
        self.items.append(item)
        return self
    }
    
    public func addItem(title: String, icon: UIImage? = nil, color: UIColor? = nil, alignment: NSTextAlignment = .Left, checked: Bool = false, handler: (() -> Void)? = nil) -> PopoverMenu {
        self.items.append(Item(title: title, icon: icon, color: color, alignment: alignment, checked: checked, handler: handler))
        return self
    }
    
    public func setSelected(selected: Int) -> PopoverMenu {
        self.items[selected].checked = true
        return self
    }

    public func show(from parent: UIViewController, anchor: AnyObject, completion: (() -> Void)? = nil) {
        let controller = PopoverMenuController(menu: self)
        controller.modalPresentationStyle = .Popover
        controller.popoverPresentationController!.delegate = controller
        switch anchor {
        case let barItem as UIBarButtonItem:
            controller.popoverPresentationController!.barButtonItem = barItem
        case let sourceView as UIView:
            controller.popoverPresentationController!.sourceView = sourceView
        default:
            break
        }
        parent.presentViewController(controller, animated: true, completion: completion)
    }

    public func show(from parent: UIViewController, anchorRect: CGRect, completion: (() -> Void)? = nil) {
        let controller = PopoverMenuController(menu: self)
        controller.modalPresentationStyle = .Popover
        controller.popoverPresentationController!.delegate = controller
        controller.popoverPresentationController!.sourceRect = anchorRect
        parent.presentViewController(controller, animated: true, completion: completion)
    }
}

//---------------------------------------------------------------------------

private class PopoverMenuController : UIViewController, UIPopoverPresentationControllerDelegate {
    var menu: PopoverMenu
    
    init(menu: PopoverMenu) {
        self.menu = menu
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder decoder: NSCoder) {
        self.menu = PopoverMenu()
        super.init(coder: decoder)
    }
    
    @objc func performAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        let view = sender as! UIView
        self.menu.items[view.tag].handler?()
    }

    override func loadView() {
        let options = self.menu.options ?? PopoverMenu.options
        let menuItems = self.menu.items
        
        let titleFont = options.font
        var maxIconWidth: CGFloat = 0
        var maxItemHeight: CGFloat = 0
        var maxItemWidth: CGFloat = 0
        var hasChecked = false

        for menuItem in menuItems {
            maxIconWidth = max(maxIconWidth, menuItem.icon?.size.width ?? 0)
        }

        if maxIconWidth > 0 {
            maxIconWidth += options.iconGap
        }

        for menuItem in menuItems {
            let titleSize = menuItem.title.sizeWithAttributes([ NSFontAttributeName: titleFont ])
            let imageSize = menuItem.icon?.size ?? CGSizeZero

            let itemHeight = max(titleSize.height, imageSize.height) + options.marginY * 2
            var itemWidth = titleSize.width + options.marginX * 2
            if menuItem.enabled && menuItem.icon != nil {
                itemWidth += maxIconWidth
            }
            
            maxItemHeight = max(maxItemHeight, itemHeight)
            maxItemWidth = max(maxItemWidth, itemWidth)
            hasChecked = hasChecked || menuItem.checked
        }

        maxItemWidth = max(maxItemWidth, options.minItemWidth)
        maxItemWidth = min(maxItemWidth, UIScreen.mainScreen().bounds.size.width * 0.9)
        maxItemHeight = max(maxItemHeight, options.minItemHeight)

        var checkmarkImage: UIImage?
        if hasChecked {
            checkmarkImage = UIImage(named: "mark_checked")
            checkmarkImage = checkmarkImage!.imageWithRenderingMode(.AlwaysTemplate)
            maxItemWidth += options.iconGap + checkmarkImage!.size.width
        }

        let titleX = options.marginX + maxIconWidth
        let titleWidth = maxItemWidth - titleX - options.marginX

        let selectedBackground = createSelectedImage(CGSizeMake(maxItemWidth, maxItemHeight + 2))
        let dividerLine = createGradientLine(CGSizeMake(maxItemWidth - options.marginX * 2, 1))
        
        let contentView = UIScrollView(frame: CGRectZero)
        contentView.autoresizingMask = .None
        contentView.backgroundColor = UIColor.clearColor()
        contentView.opaque = false

        let tintColor = UIButton.appearance().tintColor
        var itemY = options.marginY
        var itemNum = 0

        for menuItem in menuItems {
            let itemFrame = CGRectMake(0, itemY, maxItemWidth, maxItemHeight)

            let itemView = UIView(frame: itemFrame)
            itemView.autoresizingMask = .None
            itemView.backgroundColor = UIColor.clearColor()
            itemView.opaque = false

            contentView.addSubview(itemView)

            if menuItem.enabled {
                let button = UIButton(type: .Custom)
                button.tag = itemNum
                button.frame = itemView.bounds
                button.enabled = menuItem.enabled
                button.backgroundColor = UIColor.clearColor()
                button.opaque = false
                button.autoresizingMask = .None
                button.addTarget(self, action: "performAction:", forControlEvents: .TouchUpInside)
                button.setBackgroundImage(selectedBackground, forState: .Highlighted)
                itemView.addSubview(button)
            }

            if menuItem.title.length > 0 {
                let titleFrame: CGRect
                if !menuItem.enabled && menuItem.icon == nil {
                    titleFrame = CGRectMake(
                            options.marginX,
                            options.marginY,
                            maxItemWidth - options.marginX * 2,
                            maxItemHeight - options.marginY * 2)
                } else {
                    titleFrame = CGRectMake(
                            titleX,
                            options.marginY,
                            titleWidth,
                            maxItemHeight - options.marginY * 2)
                }

                let titleLabel = UILabel(frame: titleFrame)
                titleLabel.text = menuItem.title
                titleLabel.font = titleFont
                titleLabel.textAlignment = menuItem.alignment
                titleLabel.textColor = menuItem.color ?? UIColor.blackColor()
                titleLabel.backgroundColor = UIColor.clearColor()
                titleLabel.autoresizingMask = .None
                itemView.addSubview(titleLabel)
            }

            if let icon = menuItem.icon {
                let imageFrame = CGRectMake(
                        options.marginX,
                        options.marginY,
                        maxIconWidth - options.iconGap,
                        maxItemHeight - options.marginY * 2)
                let imageView = UIImageView(frame: imageFrame)
                imageView.image = icon.imageWithRenderingMode(.AlwaysTemplate)
                imageView.clipsToBounds = true
                imageView.contentMode = .Center
                imageView.autoresizingMask = .None
                imageView.tintColor = tintColor
                itemView.addSubview(imageView)
            }

            if let checkmarkImage = checkmarkImage where menuItem.checked {
                let checkmarkView = UIImageView(image: checkmarkImage)
                checkmarkView.frame = CGRectMake(
                        maxItemWidth - options.marginX - checkmarkImage.size.width,
                        options.marginY,
                        checkmarkImage.size.width,
                        maxItemHeight - options.marginY * 2)
                checkmarkView.contentMode = .Center
                checkmarkView.tintColor = tintColor
                itemView.addSubview(checkmarkView)
            }

            if options.showSeparator && itemNum < menuItems.count - 1 {
                let dividerView = UIImageView(image: dividerLine)
                dividerView.frame = CGRectMake(
                        options.marginX,
                        maxItemHeight + 1,
                        dividerLine.size.width,
                        dividerLine.size.height)
                dividerView.contentMode = .Left
                itemView.addSubview(dividerView)
                itemY += dividerLine.size.height + 2
            }

            itemY += maxItemHeight
            ++itemNum
        }

        itemY += options.marginY
        let contentHeight = min(itemY, UIScreen.mainScreen().bounds.height * 0.8)
        contentView.contentSize = CGSizeMake(maxItemWidth, itemY)
        contentView.frame = CGRectMake(0, 0, maxItemWidth, contentHeight)
        self.preferredContentSize = contentView.frame.size
        self.view = contentView
    }
    
    @objc func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}

//---------------------------------------------------------------------------

private func createSelectedImage(size: CGSize) -> UIImage {
    let locations: [CGFloat] = [ 0, 1 ]
    let components: [CGFloat] = [
        0.44, 0.44, 0.44, 1,
        0.44, 0.44, 0.44, 1,
    ]
    return createGradientImage(size, locations: locations, components: components)
}

private func createGradientLine(size: CGSize) -> UIImage {
    let locations: [CGFloat] = [ 0, 0.5, 1 ]
    let components: [CGFloat] = [
        0.44, 0.44, 0.44, 0.3,
        0.44, 0.44, 0.44, 0.5,
        0.44, 0.44, 0.44, 0.3
    ]
    return createGradientImage(size, locations: locations, components: components)
}

private func createGradientImage(size: CGSize, locations: [CGFloat], components: [CGFloat]) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    let context = UIGraphicsGetCurrentContext()

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, locations.count)
    CGContextDrawLinearGradient(context, colorGradient, CGPointZero, CGPointMake(size.width, 0), [])

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}

