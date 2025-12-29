pragma solidity ^0.8.0;

contract AgriSupplyChain {
    struct Produce {
        string name;
        string origin;
        uint256 quantity;
        uint256 price;
        address owner;
    }

    Produce[] public produceList;

    event ProduceAdded(uint256 indexed id, string name, address owner);
    event OwnershipTransferred(uint256 indexed id, address oldOwner, address newOwner);

    function addProduce(
        string memory name,
        string memory origin,
        uint256 quantity,
        uint256 price
    ) public {
        require(bytes(name).length > 0, "Name required");
        require(bytes(origin).length > 0, "Origin required");
        require(quantity > 0, "Quantity must be > 0");
        require(price > 0, "Price must be > 0");

        produceList.push(Produce({
            name: name,
            origin: origin,
            quantity: quantity,
            price: price,
            owner: msg.sender
        }));

        emit ProduceAdded(produceList.length - 1, name, msg.sender);
    }

    function getProduceCount() public view returns (uint256) {
        return produceList.length;
    }

    function getProduce(uint256 index) public view returns (
        string memory,
        string memory,
        uint256,
        uint256,
        address
    ) {
        require(index < produceList.length, "Invalid produce ID");
        Produce memory p = produceList[index];
        return (p.name, p.origin, p.quantity, p.price, p.owner);
    }

    function transferOwnership(uint256 index, address newOwner) public {
        require(index < produceList.length, "Invalid produce ID");
        Produce storage p = produceList[index];
        require(msg.sender == p.owner, "Only owner can transfer");
        require(newOwner != address(0), "Invalid new owner");

        address oldOwner = p.owner;
        p.owner = newOwner;

        emit OwnershipTransferred(index, oldOwner, newOwner);
    }
}