//
//  FeedCollectionCell.swift
//  Eatopine
//
//  Created by Borna Beakovic on 15/08/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

protocol FeedListCellDelegate {
    func heightChanged(feedCell: FeedListCell, newHeight: CGFloat, forceResize: CGSize)
    func pushRestName(dish:EPDish)
    func pushImgProfile(dish:EPDish)
    func pushLike(dish:EPDish, liked:Bool)
    func pushComment(dish:EPDish)
    func pushOption(dish:EPDish)
    func pushGetLikes(dish:EPDish)
    func pushGetComments(dish:EPDish)
    func pushDishName(dish:EPDish)
}

class FeedListCell: UITableViewCell, FoodContentViewDelegate {

    @IBOutlet weak var foodContent: FoodContentView!
    var theDish: EPDish?
    var delegate: FeedListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setContent(dish:EPDish) {
        theDish = dish
        foodContent.delegate = self
        foodContent.setContent(dish)
    }
    
    func setScrollable(bFlag:Bool) {
        foodContent.contentScroll.scrollEnabled = bFlag
    }
    
    //Mark: FoodContentView Protocol
    func heightChanged(newHeight: CGFloat) {
        self.delegate?.heightChanged(self, newHeight: newHeight, forceResize: CGSize.zero)
    }
    
    func pushRestName() {
        delegate?.pushRestName(theDish!)
    }
    
    func pushImgProfile() {
        delegate?.pushImgProfile(theDish!)
    }
    
    func pushLike(liked: Bool) {
        delegate?.pushLike(theDish!, liked: liked)
    }
    
    func pushComment() {
        delegate?.pushComment(theDish!)
    }
    
    func pushOption() {
        delegate?.pushOption(theDish!)
    }
    
    func pushGetLikes() {
        delegate?.pushGetLikes(theDish!)
    }
    
    func pushGetComments() {
        delegate?.pushGetComments(theDish!)
    }
    
    func pushDishName() {
        delegate?.pushDishName(theDish!)
    }
}
