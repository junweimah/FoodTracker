import UIKit

@IBDesignable class RatingControl: UIStackView {
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet { // will call this method whenever the rating changes value
            print("before calling update button when changing rating value");
            updateButtonSelectionStates();
        }
    };
    
    //inspectable means these 2 var can be inspect and adjust in storyboard, ulilities, top right
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet{
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet{
            setupButtons()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    func ratingButtonTapped(button: UIButton){
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        //calculate the user rating
        let selectedRating = index + 1
        
        if selectedRating == rating{
            rating = 0
        }else{
            rating = selectedRating
        }
    }
    
    
    //MARK: Private Methods
    private func setupButtons(){
        // clear any existing buttons
        for button in ratingButtons{
            removeArrangedSubview((button))
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        //load image button from assets
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith:self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith:self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith:self.traitCollection)
        
        for index in 0..<starCount{
            //create button
            let button = UIButton()
            
            //set button images
            button.setImage(emptyStar, for: .normal) //this is default image
            button.setImage(filledStar, for: .selected)
            button.setImage(emptyStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            //add constraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //set the accesssibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // add the button to the stack
            //The addArrangedSubview() method adds the button you created to the list of views managed by the RatingControl stack view. This action adds the view as a subview of the RatingControl
            addArrangedSubview(button)
            
            //add the created button into the array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates();
    }
    private func updateButtonSelectionStates() {
        for(index, button) in ratingButtons.enumerated(){
            // if the index of a button is less than the rating, that button should be selected
            button.isSelected = index < rating
            // set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1{
                hintString = "Tap to reset the rating to zero."
            }else{
                hintString = nil
            }
            
            //calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "no rating set."
            case 1:
                valueString = "1 rating set."
                
            default:
                valueString = "\(rating) star set."
            }
            
            //assign those string as accessibility value
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
            
        }
    }

}
