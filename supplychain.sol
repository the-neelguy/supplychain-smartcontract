// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SupplyChain {
    receive() external payable {}

    mapping (address => bool) farmers;
    mapping (address => bool) manufacturers;
    mapping (address => bool) distributors;
    mapping (address => bool) retailers;
    mapping (address => bool) consumers;

    event FarmerAdded(address indexed account);
    event FarmerRemoved(address indexed account);
    event DistributorAdded(address indexed account);
    event DistributorRemoved(address indexed account);
    event RetailerAdded(address indexed account);
    event RetailerRemoved(address indexed account);
    event ManufacturerAdded(address indexed account);
    event ManufacturerRemoved(address indexed account);
    event ConsumerAdded(address indexed account);
    event ConsumerRemoved(address indexed account);
    event ProduceByFarmer(uint256 productCode);
    event ForSaleByFarmer(uint256 productCode);
    event PurchasedByManufacturer(uint256 productCode);
    event ShippedByFarmer(uint256 productCode);
    event ReceivedByManufacturer(uint256 productCode);
    event ProcessedByManufacturer(uint256 productCode);
    event PackagedByManufacturer(uint256 productCode);
    event ForSaleByManufacturer(uint256 productCode);
    event PurchasedByDistributor(uint256 productCode);
    event ShippedByManufacturer(uint256 productCode);
    event ReceivedByDistributor(uint256 productCode);
    event ForSaleByDistributor(uint256 productCode);
    event PurchasedByRetailer(uint256 productCode);
    event ShippedByDistributor(uint256 productCode);
    event ReceivedByRetailer(uint256 productCode);
    event ForSaleByRetailer(uint256 productCode);
    event PurchasedByConsumer(uint256 productCode);
    event ReceivedByConsumer(uint256 productCode);

    
    uint256 productID;

    enum State {
        ProduceByFarmer, // 0
        ForSaleByFarmer, // 1
        PurchasedByManufacturer, // 2
        ShippedByFarmer, // 3
        ReceivedByManufacturer, // 4
        ProcessedByManufacturer, // 5
        PackagedByManufacturer, // 6
        ForSaleByManufacturer, // 7
        PurchasedByDistributor, // 8
        ShippedByManufacturer, // 9
        ReceivedByDistributor, // 10
        ForSaleByDistributor, // 11
        PurchasedByRetailer, // 12
        ShippedByDistributor, // 13
        ReceivedByRetailer, // 14
        ForSaleByRetailer, // 15
        PurchasedByConsumer, // 16
        ReceivedByConsumer // 17
    }

    struct Item {
        uint256 itemID;
        string itemName;
        address ownerID;
        address consumerID;
        address farmerID;
        address manufacturerID;
        address distributorID;
        address retailerID;
        State currentState;
        uint256 itemPrice;
    }

    mapping (uint256 => Item ) items;
    
    constructor() {
        farmers[msg.sender] = true;
        manufacturers[msg.sender] = true;
        distributors[msg.sender] = true;
        consumers[msg.sender] = true;
        retailers[msg.sender] = true;
    }

    //MODIFIERS

    modifier paidEnough(uint256 _price) {
        require(msg.value >= _price);
        _;
    }

    modifier verifyCaller(address _address) {
        require(msg.sender == _address);
        _;
    }

     modifier onlyFarmer ()
    {
        require(farmers[msg.sender]);
        _;
    }

    modifier onlyDistributor ()
    {
        require(distributors[msg.sender]);
        _;
    }

    modifier onlyManufacturer ()
    {
        require(manufacturers[msg.sender]);
        _;
    }

    modifier onlyRetailer ()
    {
        require(retailers[msg.sender]);
        _;
    }

    modifier onlyConsumer ()
    {
        require(consumers[msg.sender]);
        _;
    }

    modifier producedByFarmer(uint256 _productCode) {
        require(items[_productCode].currentState == State.ProduceByFarmer);
        _;
    }


    //FUNCTIONS
    function getState(uint256 id) public view returns (State) {
        return items[id].currentState;
    }

    function getOwnership(uint256 id) public view returns (address) {
        return items[id].ownerID;
    }


    function produceItemByFarmer(uint256 prodcode, string memory name) public onlyFarmer 
    {
        Item memory newProduce;
        newProduce.itemID = prodcode;
        newProduce.itemName = name; 
        newProduce.ownerID = msg.sender;
        newProduce.farmerID = msg.sender; 
        newProduce.currentState = State.ProduceByFarmer; 
        items[prodcode] = newProduce; 
        emit ProduceByFarmer(prodcode);
    }

    function sellItemByFarmer(uint256 prodcode, uint256 price)
        public
        onlyFarmer
        producedByFarmer(prodcode)
        verifyCaller(items[prodcode].farmerID)
    {
        items[prodcode].currentState = State.ForSaleByFarmer;
        items[prodcode].itemPrice = price;
        emit ForSaleByFarmer(prodcode);
    }

    function purchaseByManufacturer(uint256 prodcode) public onlyManufacturer payable
    {
        require(items[prodcode].currentState==State.ForSaleByFarmer);
        require(msg.value >= items[prodcode].itemPrice);
        address payable ownerAddressPayable = payable(items[prodcode].farmerID);
        ownerAddressPayable.transfer(items[prodcode].itemPrice);
        items[prodcode].manufacturerID = msg.sender;
        items[prodcode].ownerID = msg.sender;
        items[prodcode].currentState= State.PurchasedByManufacturer;
        emit PurchasedByDistributor(prodcode);

    }

    function shipItemByFarmer(uint256 prodcode) public onlyFarmer 
    {
        require(items[prodcode].currentState==State.PurchasedByManufacturer);
        require(items[prodcode].farmerID==msg.sender);
        items[prodcode].currentState=State.ShippedByFarmer;
        emit ShippedByFarmer(prodcode);
    }

    function receiveByManufacturer(uint256 prodcode) public onlyManufacturer 
    {
        require(items[prodcode].currentState==State.ShippedByFarmer);
        require(items[prodcode].manufacturerID==msg.sender);
        items[prodcode].currentState=State.ReceivedByManufacturer;
        emit ReceivedByManufacturer(prodcode);
    }
    
    function processByManufacturer(uint256 prodcode) public onlyManufacturer 
    {
        require(items[prodcode].currentState == State.ReceivedByManufacturer);
        require(items[prodcode].manufacturerID == msg.sender);
        items[prodcode].currentState = State.ProcessedByManufacturer;
        emit ProcessedByManufacturer(prodcode);
    }

    function packageByManufacturer(uint256 prodcode) public onlyManufacturer  
    {
        require(items[prodcode].currentState == State.ProcessedByManufacturer);
        require(items[prodcode].manufacturerID == msg.sender);
        items[prodcode].currentState = State.PackagedByManufacturer;
        emit PackagedByManufacturer(prodcode);
    }

    function sellItemByManufacturer(uint256 prodcode, uint256 price) public onlyManufacturer 
    {
        require(items[prodcode].currentState == State.PackagedByManufacturer);
        require(items[prodcode].manufacturerID == msg.sender);
        items[prodcode].itemPrice = price;
        items[prodcode].currentState = State.ForSaleByManufacturer;
        emit ForSaleByManufacturer(prodcode);
    }

    function purchaseByDistributor(uint256 prodcode) public payable 
    {
        require(items[prodcode].currentState == State.ForSaleByManufacturer);
        require(msg.value >= items[prodcode].itemPrice);
        address payable ownerAddressPayable = payable(items[prodcode].manufacturerID);
        ownerAddressPayable.transfer(items[prodcode].itemPrice);
        items[prodcode].distributorID = msg.sender;
        items[prodcode].ownerID = msg.sender;
        items[prodcode].currentState = State.PurchasedByDistributor;
        emit PurchasedByDistributor(prodcode);
    }

    function shipItemByManufacturer(uint256 prodcode) public onlyManufacturer 
    {
        require(items[prodcode].currentState == State.PurchasedByDistributor);
        require(items[prodcode].manufacturerID == msg.sender);
        items[prodcode].currentState = State.ShippedByManufacturer;
        emit ShippedByManufacturer(prodcode);
    }

    function receiveByDistributor(uint256 prodcode) public onlyDistributor 
    {
        require(items[prodcode].currentState == State.ShippedByManufacturer);
        require(items[prodcode].distributorID == msg.sender);
        items[prodcode].currentState = State.ReceivedByDistributor;
        emit ReceivedByDistributor(prodcode);
    }

    function sellItemByDistributor(uint256 prodcode, uint256 price) public onlyDistributor 
    {
        require(items[prodcode].currentState == State.ReceivedByDistributor);
        require(items[prodcode].distributorID == msg.sender);
        items[prodcode].itemPrice = price;
        items[prodcode].currentState = State.ForSaleByDistributor;
        emit ForSaleByDistributor(prodcode);
    }

    function purchaseByRetailer(uint256 prodcode) public payable 
    {
        require(items[prodcode].currentState == State.ForSaleByDistributor);
        require(msg.value >= items[prodcode].itemPrice);
        address payable ownerAddressPayable = payable(items[prodcode].distributorID);
        ownerAddressPayable.transfer(items[prodcode].itemPrice);
        items[prodcode].retailerID = msg.sender;
        items[prodcode].ownerID = msg.sender;
        items[prodcode].currentState = State.PurchasedByRetailer;
        emit PurchasedByRetailer(prodcode);
    }

    function shipItemByDistributor(uint256 prodcode) public onlyDistributor 
    {
        require(items[prodcode].currentState == State.PurchasedByRetailer);
        require(items[prodcode].distributorID == msg.sender);
        items[prodcode].currentState = State.ShippedByDistributor;
        emit ShippedByDistributor(prodcode);
    }

    function receiveByRetailer(uint256 prodcode) public onlyRetailer 
    {
        require(items[prodcode].currentState == State.ShippedByDistributor);
        require(items[prodcode].retailerID == msg.sender);
        items[prodcode].currentState = State.ReceivedByRetailer;
        emit ReceivedByRetailer(prodcode);
    }

    function sellItemByRetailer(uint256 prodcode, uint256 price) public onlyRetailer 
    {
        require(items[prodcode].currentState == State.ReceivedByRetailer);
        require(items[prodcode].ownerID == msg.sender);
        items[prodcode].itemPrice = price;
        items[prodcode].currentState = State.ForSaleByRetailer;
        emit ForSaleByRetailer(prodcode);
    }

    function purchaseByConsumer(uint256 prodcode) public payable 
    {
        require(items[prodcode].currentState == State.ForSaleByRetailer);
        require(msg.value >= items[prodcode].itemPrice);
        address payable ownerAddressPayable = payable(items[prodcode].retailerID);
        ownerAddressPayable.transfer(items[prodcode].itemPrice);
        items[prodcode].consumerID = msg.sender;
        items[prodcode].ownerID = msg.sender;
        items[prodcode].currentState = State.PurchasedByConsumer;
        emit PurchasedByConsumer(prodcode);
    }

    function receivedByConsumer(uint256 prodcode) public onlyConsumer 
    {
        require(items[prodcode].currentState == State.PurchasedByConsumer);
        require(items[prodcode].consumerID == msg.sender);
        items[prodcode].currentState = State.ReceivedByConsumer;
        emit ReceivedByConsumer(prodcode);
    }

    

    
    //To manage farmers
    function addFarmer(address account) public onlyFarmer {
        require(account != address(0));
        require(!farmers[account]);
        farmers[account] = true;
        emit FarmerAdded(account);
    }

    function removeFarmer(address account) public onlyFarmer {
        require(account != address(0));
        require(farmers[account]);
        farmers[account] = false;
        emit FarmerRemoved(account);
    }

   
    //To manage distributors
    function addDistributor (address account) public onlyDistributor {
        require(account != address(0));
        require(!distributors[account]);
        distributors[account] = true;
        emit DistributorAdded(account);
    }

    function removeDistributor (address account) public onlyDistributor {
        require(account != address(0));
        require(distributors[account]);
        distributors[account] = false;
        emit DistributorRemoved(account);
    }

    
    //To manage retailers
    function addRetailer (address account) public onlyRetailer {
        require(account != address(0));
        require(!retailers[account]);
        retailers[account] = true;
        emit RetailerAdded(account);
    }

    function removeRetailer (address account) public onlyRetailer {
        require(account != address(0));
        require(retailers[account]);
        retailers[account] = false;
        emit RetailerRemoved(account);
    }

    

    //To manage consumers
    function addConsumer (address account) public onlyConsumer {
        require(account != address(0));
        require(!consumers[account]);
        consumers[account] = true;
        emit ConsumerAdded(account);
    }

    function removeConsumer (address account) public onlyConsumer {
        require(account != address(0));
        require(consumers[account]);
        consumers[account] = false;
        emit ConsumerRemoved(account);
    }

    //To manage manufacturers
    function addManufacturer (address account) public onlyManufacturer {
        require(account != address(0));
        require(!manufacturers[account]);
        manufacturers[account] = true;
        emit ManufacturerAdded(account);
    }

    function removeManufacturer (address account) public onlyManufacturer {
        require(account != address(0));
        require(manufacturers[account]);
        manufacturers[account] = false;
        emit ManufacturerRemoved(account);
    }
}
