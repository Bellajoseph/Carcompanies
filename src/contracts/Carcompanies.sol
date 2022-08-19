// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;


interface IERC20Token {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function transferFrom(address, address, uint256) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);


  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract Carcompanies {

    uint internal carLength = 0;
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;


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
        uint dislikes;
        uint price;
        uint available;
        uint numberOfreview;
    }

    mapping(uint256=> Car) internal cars;
    mapping (uint => Review[]) internal reviewsMap;// mapping reviews
    mapping(uint => mapping(address => bool)) internal hasBought;


    modifier onlyOwner(uint _index){
        require(msg.sender == cars[_index].owner, "Only the owner can access this function");
        _;
    }

    function addCar(
        string memory _brand,
        string memory _model,
        string memory _image,
        uint _price,
        uint _carsAvailable
    )public{
        cars[carLength] = Car(
            payable(msg.sender),
            _brand,
            _model,
            _image,
            0,
            0,
            _price,
            _carsAvailable,
            0
        );
        carLength++;
    }

    function getCar(uint _index)public view returns(
        address payable,
        string memory,
        string memory,
        string memory,
        uint,
        uint,
        uint,
        uint,
        uint,
        Review[] memory
    ){
        Car memory c = cars[_index];
        Review[] memory reviews = reviewsMap[_index];
        return (
            c.owner,
            c.brand,
            c.model,
            c.image,
            c.likes,
            c.dislikes,
            c.price,
            c.available,
            c.numberOfreview,
            reviews
        );
    }

    // like the car
    function likeCar(uint index)public{
        cars[index].likes++;
    }

    // leave a dislike for the car
    function dislikeCar(uint index)public{
        cars[index].dislikes++;
    }

    // add a revie to a book
   function addReview(uint _index, string memory _reviews) public{
    require(hasBought[_index][msg.sender], "Only buyers can review the cars");
    reviewsMap[_index].push(Review(_index, address(msg.sender), _reviews));
    cars[_index].numberOfreview++;
    }


    function buyCar(uint _index, uint256 _quantity) public payable  {
        Car storage car = cars[_index];
        require(msg.sender != car.owner, "Owner can't buy their own car");
        require(car.available >= _quantity, "Not sufficient car available" );
        require(
          IERC20Token(cUsdTokenAddress).transferFrom(
            msg.sender,
            cars[_index].owner,
            cars[_index].price * _quantity
          ),
          "Can not perform transactions."
        );
        cars[_index].available-= _quantity;
        hasBought[_index][msg.sender] = true;
    }

    //Function to change the price of the car
    function changePrice(uint _index, uint _price)public onlyOwner(_index){
        cars[_index].price = _price;
    }

    //Function to add more cars
    function addStock(uint _index, uint _stock)public onlyOwner(_index){
        cars[_index].available += _stock;
    }

    //acquiring length of cars
    function getCarLength() public view returns(uint){
        return carLength;
    }

    // acquiring length of reviews 
    function getreviewsLength(uint _index) public view returns (uint) {
        return reviewsMap[_index].length;
    }
} 
