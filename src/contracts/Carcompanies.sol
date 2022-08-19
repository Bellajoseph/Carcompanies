// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
    function transfer(address, uint256) external returns (bool);

    function approve(address, uint256) external returns (bool);

    function transferFrom(
        address,
        address,
        uint256
    ) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function allowance(address, address) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Carcompanies {
    uint internal carLength = 0;
    address internal cUsdTokenAddress =
        0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;

    // declaring the struct for the review
    struct Review {
        uint256 postId;
        address reviewerAddress;
        string reviewerMessage;
    }

    struct Car {
        address payable owner;
        string brand;
        string model;
        string image;
        uint likes;
        uint price;
        uint carsAvailable;
        uint numberOfreview;
    }

    mapping(uint256 => Car) internal cars;
    mapping(uint => Review[]) internal reviewsMap; // mapping reviews
    mapping(uint => mapping(address => bool)) public reviewed; // keeps track of whether a user has reviewed a car
    mapping(uint => mapping(address => bool)) public liked; // keeps track of whether a user has liked a car
    mapping(uint => bool) public exists;

    modifier exist(uint _index) {
        require(exists[_index], "Query of nonexistent car");
        _;
    }

    /// @dev allows users to upload a car model for sale
    function addCar(
        string calldata _brand,
        string calldata _model,
        string calldata _image,
        uint _price,
        uint _carsAvailable
    ) external {
        require(bytes(_brand).length > 0, "Empty car brand");
        require(bytes(_model).length > 0, "Empty car model");
        require(bytes(_image).length > 0, "Empty image url");
        require(_price > 0, "Price must be at least one wei");
        require(_carsAvailable > 0, "At least one car must be available");
        cars[carLength] = Car(
            payable(msg.sender),
            _brand,
            _model,
            _image,
            0,
            _price,
            _carsAvailable,
            0
        );
        exists[carLength] = true;
        carLength++;
    }

    function getCar(uint _index)
        public
        view
        returns (
            address payable,
            string memory,
            string memory,
            string memory,
            uint,
            uint,
            uint,
            uint,
            Review[] memory
        )
    {
        Car memory c = cars[_index];
        Review[] memory reviews = reviewsMap[_index];
        return (
            c.owner,
            c.brand,
            c.model,
            c.image,
            c.likes,
            c.price,
            c.carsAvailable,
            c.numberOfreview,
            reviews
        );
    }

    /// @dev like the car
    function likesCar(uint _index) public exist(_index) {
        require(!liked[_index][msg.sender], "Already liked");
        cars[_index].likes++;
        liked[_index][msg.sender] = true;
    }

    /// @dev leave a dislike for the car
    /// @notice only user who liked can dislike
    function dislikesCar(uint _index) public exist(_index) {
        require(!liked[_index][msg.sender], "You haven't liked this car yet");
        cars[_index].likes--;
        liked[_index][msg.sender] = false;
    }

    /// @dev add a review to a book
    /// @notice only one review per user
    function addReview(uint _index, string calldata _reviews)
        public
        exist(_index)
    {
        require(!reviewed[_index][msg.sender], "Already reviewed");
        require(bytes(_reviews).length > 0, "Review message can't be empty");
        reviewsMap[_index].push(Review(_index, address(msg.sender), _reviews));
        reviewed[_index][msg.sender] = true;
        cars[_index].numberOfreview++;
    }

    /// @dev allows users to buy a car
    function buyCar(uint _index) public payable exist(_index) {
        require(cars[_index].carsAvailable > 0, "sold out");
        require(cars[_index].owner != msg.sender, "You can't buy your own car");
        require(
            IERC20Token(cUsdTokenAddress).transferFrom(
                msg.sender,
                cars[_index].owner,
                cars[_index].price
            ),
            "Can not perform transactions."
        );
        cars[_index].carsAvailable--;
    }

    /// @dev allows cars' owners to restock their inventory
    function reStockInventory(uint _index, uint amount) public {
        require(cars[_index].owner == msg.sender, "You can't buy your own car");
        require(amount > 0, "Restocking amount must at least be one");
        cars[_index].carsAvailable += amount;
    }

    /// @dev acquiring length of cars
    function getCarLength() public view returns (uint) {
        return carLength;
    }

    /// @dev acquiring length of reviews
    function getreviewsLength(uint _index) public view returns (uint) {
        return reviewsMap[_index].length;
    }
}
