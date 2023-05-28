// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ERC721M.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyEnforcedRoyaltiesNFT is ERC721M, Ownable {
    using Strings for uint256;

    bool enforcement = true;
    string baseURI;
    uint256 mintPrice = 0.08 ether;
    uint256 _flatRateTransferFee = 0.1 ether;
    uint256 _royaltyFee = 1000;
    address payable _royaltyReceiver;


    constructor(string memory name, string memory symbol, string memory _baseURI, address payable royaltyReceiver_) ERC721M(name, symbol, _royaltyFee, royaltyReceiver_, address(this)) {
        baseURI = _baseURI;
        _royaltyReceiver = royaltyReceiver_;
    }

    function airdrop(address to) public onlyOwner {
        _safeMint(to, 1, '');
    }

    function paidMint(address to, uint256 numberOfTokens) public payable {
        require(msg.value >= (numberOfTokens * mintPrice), "Must send minimum value to mint");
        royaltyReceiver().transfer(msg.value);
        _safeMint(to, numberOfTokens, '');
    }

    function tokenURI(uint256 tokenID) public override view returns (string memory) {
        if (!_exists(tokenID)) revert URIQueryForNonexistentToken();
            return string.concat(baseURI,Strings.toString(tokenID));
    }

    // =============================================================
    //                       OPTIONAL CUSTOMIZATION
    // =============================================================

    function updateFee(uint256 newFee) public onlyOwner {
        _flatRateTransferFee = newFee;
    }

    function updateFlatTransferFee(uint256 newFee) public onlyOwner {
        _royaltyFee = newFee;
    }

    function updateRoyaltyReceiver(address payable newReceiver) public onlyOwner {
        _royaltyReceiver = newReceiver;
    }

    function toggleEnforcement() public onlyOwner {
        enforcement = !enforcement;
    }

    function flatRateFee() public view override returns (uint256) {
    // Flat rate transfers will be disabled by default unless the flatRateFee() is overriden
        return _flatRateTransferFee;
    }

    function royaltyEnforcementEnabled() public view override returns (bool) {
        return enforcement;
    }

    function royaltyFee() public view override returns (uint256) {
        return _royaltyFee;
    }

    function royaltyReceiver() public view override returns (address payable) {
        return _royaltyReceiver;
    }
}