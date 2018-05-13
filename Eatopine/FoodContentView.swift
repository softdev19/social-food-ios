//
//  FoodContentView.swift
//  Eatopine
//
//  Created by  on 9/22/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

let kLabelHeight: CGFloat = 16
let kAllViewHeight: CGFloat = 30.0
let kLabelMargin: CGFloat = 14
let kCommentMaxLength = 80
let kCommentFontSize: CGFloat = 16.0

@objc protocol FoodContentViewDelegate: class {
    @objc optional func heightChanged(newHeight:CGFloat)
    @objc optional func pushRestName()
    @objc optional func pushImgProfile()
    @objc optional func pushLike(liked:Bool)
    @objc optional func pushComment()
    @objc optional func pushOption()
    @objc optional func pushGetLikes()
    @objc optional func pushGetComments()
    @objc optional func pushDishName()
}

class FoodContentView: UIView {
    
    var view: UIView!
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var contentScroll: UIScrollView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbResName: UILabel!
    @IBOutlet weak var btnRestName: UIButton!
    @IBOutlet weak var btnImgProfile: UIButton!
    @IBOutlet weak var btnUserName: UIButton!
    @IBOutlet weak var lbTime: UILabel!
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnOption: UIButton!
    
    @IBOutlet weak var comment1: UILabel!
    @IBOutlet weak var comment2: UILabel!
    
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var lbLikes: UILabel!
    @IBOutlet weak var btnLikesCount: UIButton!
    @IBOutlet weak var btnCommentsCount: UIButton!
    
    
    @IBOutlet weak var vRatingBar: EatopineRatingView!
    
    @IBOutlet weak var lbDishName: UILabel!
    @IBOutlet weak var lbRatingText: UILabel!
    @IBOutlet weak var btnDishName: UIButton!
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var lbViewAllComments: UILabel!
    @IBOutlet weak var btnViewAllComments: UIButton!
    
    @IBOutlet weak var vRatingTextView: UIView!
    @IBOutlet weak var vCommentView1: UIView!
    @IBOutlet weak var vCommentView2: UIView!
    @IBOutlet weak var vAllCommentView: UIView!
    
    
    @IBOutlet weak var resNameWConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dishTextHConstraint: NSLayoutConstraint!
    @IBOutlet weak var dishNameHConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var photoWConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoHConstraint: NSLayoutConstraint!

    
    
    @IBOutlet weak var comment1HConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var comment2HConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewAllHConstraint: NSLayoutConstraint!
    
    var delegate: FoodContentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
        xibSetup()
    }

    
    func xibSetup() {
        view = loadViewFromNib()
        
        view.frame = bounds
        
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "FoodContentView", bundle: bundle)
        
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func setContent(dish:EPDish) {
        
        let width = UIScreen.mainScreen().bounds.size.width
        
        imgProfile.sd_setImageWithURL(NSURL(string: dish.profile_picture), placeholderImage: UIImage(named: "generic_avatar"))
        AppUtility.makeCircleImageView(imgProfile)
        
        photo.sd_setImageWithURL(NSURL(string: dish.photo), placeholderImage: UIImage(named: "restaurant_placeholder"))
        
        lbUserName.text = dish.username
        lbResName.text = dish.restaurant_name
        lbTime.text = AppUtility.getMinutesFromToday(dish.created)
        
        lbLikes.text = String(dish.n_likes)
        commentsCount.text = String(dish.n_comments)
        
        //resNameWConstraint.constant = dish.restaurant_name.widthWithConstrainedHeight(kLabelHeight, font: UIFont.systemFontOfSize(kCommentFontSize))
        
        vRatingBar.setupForEatopineSmall()
        vRatingBar.rating = CGFloat(dish.vote)
        
        if dish.dish_name == "" {
            dishNameHConstraint.constant = 0
        }
        else {
            lbDishName.text = dish.dish_name
            dishNameHConstraint.constant = kLabelHeight
        }
        
        if dish.rating_text == "" {
            dishTextHConstraint.constant = 0
        }
        else {
            lbRatingText.text = dish.rating_text
            dishTextHConstraint.constant = dish.rating_text.heightWithConstrainedWidth(width, font: UIFont.systemFontOfSize(kCommentFontSize))
        }
        
        if (dish.comments.count == 0) {
            comment1HConstraint.constant = 0
            comment2HConstraint.constant = 0
            borderView.hidden = true
        }
        
        if (dish.comments.count > 0 ) {
            borderView.hidden = false
            let comment = dish.comments[0]
            var commentStr = comment.username + " " + comment.text
            
            if (commentStr.length > kCommentMaxLength) {
                let index = commentStr.startIndex.advancedBy(kCommentMaxLength)
                commentStr = commentStr.substringToIndex(index)
                commentStr += "..."
            }
            var attrStr = NSMutableAttributedString()
            attrStr = NSMutableAttributedString(string: commentStr, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15.0)])
            
            attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range:NSRange(location: 0, length: comment.username.length))
            
            comment1.attributedText = attrStr
            
            comment1HConstraint.constant = commentStr.heightWithConstrainedWidth(width, font: UIFont.systemFontOfSize(kCommentFontSize))
            comment2HConstraint.constant = 0
        }
        
        if (dish.comments.count > 1) {
            
            let comment = dish.comments[1]
            
            var commentStr = comment.username + " " + comment.text
            
            if (commentStr.length > kCommentMaxLength) {
                let index = commentStr.startIndex.advancedBy(kCommentMaxLength)
                commentStr = commentStr.substringToIndex(index)
                commentStr += "..."
            }
            
            var attrStr = NSMutableAttributedString()
            attrStr = NSMutableAttributedString(string: commentStr, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15.0)])
            
            attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range:NSRange(location: 0, length: comment.username.length))
            
            comment2.attributedText = attrStr
            
            comment2HConstraint.constant = commentStr.heightWithConstrainedWidth(width, font: UIFont.systemFontOfSize(kCommentFontSize))
        }
        
        if dish.n_comments > 2 {
            viewAllHConstraint.constant = kAllViewHeight
        }
        else {
            viewAllHConstraint.constant = 0
        }
        
        btnViewAllComments.tag = dish.rating_id
        btnComment.tag = dish.rating_id
        btnCommentsCount.tag = dish.rating_id
        btnRestName.tag = dish.restaurant_id
        btnLikesCount.tag = dish.rating_id
        
        btnLike.setImage(UIImage(named: "like.png"), forState: UIControlState.Normal)
        btnLike.setImage(UIImage(named: "like-filled.png"), forState: UIControlState.Selected)
        
        if dish.liked == 0 {
            btnLike.selected = false
        }
        else {
            btnLike.selected = true
        }
        
        photoWConstraint.constant = UIScreen.mainScreen().bounds.size.width + 5;

        contentScroll.layoutIfNeeded()
        
        if !contentScroll.scrollEnabled {
            if let delegate = self.delegate {
                delegate.heightChanged!(contentScroll.contentSize.height + 15)
            }
        }
    }
    
    
    //Mark: Button Action
    
    @IBAction func onRestNameBtnClick(sender: UIButton) {
        delegate?.pushRestName!()
    }
    
    @IBAction func onImgProfileBtnClick(sender: UIButton) {
        delegate?.pushImgProfile!()
    }
    
    @IBAction func onLikeBtnClick(sender: UIButton) {
        if (AppUtility.isUserLogged(ShowAlert: true)) {
            if sender.selected {
                delegate?.pushLike!(false)
            }
            else {
                delegate?.pushLike!(true)
            }
            sender.selected = !sender.selected
        }
    }
    
    @IBAction func onCommentBtnClick(sender: UIButton) {
        if (AppUtility.isUserLogged(ShowAlert: true)) {
            delegate?.pushComment!()
        }
    }
    
    @IBAction func onOptionBtnClick(sender: UIButton) {
        delegate?.pushOption!()
    }
    
    @IBAction func onLikesCountBtnClick(sender: UIButton) {
        delegate?.pushGetLikes!()
    }
    
    @IBAction func onCommentCountBtnClick(sender: UIButton) {
        delegate?.pushGetComments!()
    }
    
    @IBAction func onDishNameClick(sender: UIButton) {
        delegate?.pushDishName!()
    }
}

extension String {
    
    var length: Int { return characters.count }
        
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(height:CGFloat, font:UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.max, height: height)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return  boundingBox.width
    }
}
