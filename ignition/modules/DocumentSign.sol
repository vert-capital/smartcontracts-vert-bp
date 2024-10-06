// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DocumentSign {
    struct Document {
        address owner;
        uint256 timestamp;
        mapping(address => uint256) signatures;
        address[] signers;
    }

    mapping(bytes32 => Document) public documents;

    event DocumentAdded(bytes32 indexed documentHash, address indexed owner);
    event DocumentSigned(bytes32 indexed documentHash, address indexed signer);

    function addDocument(bytes32 _documentHash) public {
        require(
            documents[_documentHash].owner == address(0),
            "Document already exists"
        );
        documents[_documentHash].owner = msg.sender;
        documents[_documentHash].timestamp = block.timestamp;
        emit DocumentAdded(_documentHash, msg.sender);
    }

    function signDocument(bytes32 _documentHash) public {
        require(
            documents[_documentHash].owner != address(0),
            "Document does not exist"
        );
        require(
            documents[_documentHash].signatures[msg.sender] == 0,
            "Already signed"
        );
        documents[_documentHash].signatures[msg.sender] = block.timestamp;
        documents[_documentHash].signers.push(msg.sender);
        emit DocumentSigned(_documentHash, msg.sender);
    }

    function getSigners(
        bytes32 _documentHash
    ) public view returns (address[] memory) {
        return documents[_documentHash].signers;
    }

    function getFirstSigner(
        bytes32 _documentHash
    ) public view returns (address) {
        return documents[_documentHash].signers[0];
    }
}
