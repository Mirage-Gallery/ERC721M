# ERC721M: Artist-First NFT Standard with Built-in Marketplace and Royalties Enforcement

## Overview
ERC721M is a novel non-fungible token (NFT) standard built on the Ethereum blockchain. This new standard revolutionizes the NFT ecosystem by addressing an underlying issue in the art world: the failure to respect artists' royalties. ERC721M enforces royalties by incorporating a built-in marketplace into the smart contract itself, which handles all token transfers. When enforcement is enabled, direct token transfers are restricted to the embedded marketplace functions, preventing individuals from avoiding artist royalties.

## Technical Description
ERC721M expands upon the ERC721A gas-efficient ERC721 implementation, inheriting its capabilities while introducing a few additional critical functionalities:

#### Integrated Marketplace: 
ERC721M has an integrated marketplace within the contract. This embedded marketplace performs all token transfers. By restricting the execution of token transfers to marketplace functions, the standard effectively eliminates royalty avoidance and ensures every sale contributes to the artists' revenue.

#### Enforced Royalties and Optional Fixed Price Transfer Fee:
The ERC721M contract has been developed with artists' rights in mind. For every token transfer that happens via our built-in marketplace, a pre-established royalty percentage is automatically directed to the original artist's wallet. This process is ingrained in the smart contract, which guarantees that artists receive a fair share of compensation from each subsequent sale of their artwork.

In addition to the percentage-based royalties, we also provide artists with an optional feature of setting a fixed price transfer fee. This feature is particularly beneficial if artists prefer to permit direct transfers that are not percentage-based, and instead operate on a fixed fee basis.

This means that every time a token is directly transferred (outside of a sale), a pre-set fee will be charged and sent to the artist. This ensures artists are rewarded each time their work is transferred, irrespective of whether it is sold or not.

This dual-approach aims to provide artists with the flexibility to choose a method that best aligns with their preferences, while ensuring that they are fairly compensated for their creativity and hard work.

#### Rapid Auction Mechanism: 
To make sales more dynamic and ensure that anyone can be outbid, ERC721M introduces a rapid auction mechanism. Once a sale is initiated, a short countdown begins, during which anyone can place a higher bid. The sale concludes when the countdown ends, with the highest bid securing the token. 

The "Rapid Auction Mechanism" in ERC721M plays a critical role in preventing bad actors from exploiting the system by deploying their own 'marketplace' contracts to wrap the token transfer and Ether transfers in a single transaction. This mechanism also prevents manipulation attempts where a bad actor could try to coordinate with another party to "sell" the NFT at an artificially low price to minimize the royalty payout. Because the rapid auction system is open to any participant who can outbid the current highest bid, the chances of such collusion successfully avoiding an appropriate royalty fee are significantly diminished.

#### One-time Free Transfer Provision:
While the ERC721M standard effectively limits direct token transfers to ensure artists' royalties aren't bypassed, it also takes into account the legitimate requirements of users for certain transactions. With the understanding that users may wish to secure their newly-acquired tokens, the standard has an allowance for one free transfer within the first 24 hours after the sale occurs.

This feature is particularly useful for individuals who prefer to mint tokens from their hot wallets—wallets connected to the internet for daily transactions—but want the security of storing their valuable assets in a cold wallet—a wallet that remains disconnected from the internet, providing superior protection from hacking attempts. This one-time free transfer allows them to do just that without any extra cost, maintaining the balance between the security needs of the users and the fair treatment of artists.

However, after this 24 hour window, any subsequent transfers must go through the embedded marketplace functions, thereby ensuring that the artists' royalties are respected. This approach, blending user convenience and artist rights, illustrates the flexibility and adaptability of the ERC721M standard, ushering in a new era in the NFT ecosystem.

## Philosophy and Impact
The introduction of ERC721M presents a philosophical pivot in the world of blockchain and decentralized systems. In designing this standard, we acknowledge a departure from the traditionally celebrated ethos of web3: absolute freedom, radical decentralization, and peer-to-peer interactions devoid of middlemen. This pivot reflects our realization that the unrestricted freedom characteristic of web3 systems, while exciting, has unfortunately been manipulated in ways that undercut the very creators that these systems set out to empower.

We've witnessed marketplaces driving prices down to zero, and subsequently exploiting artists, the lifeblood of the creative economy. Some marketplaces are currently enforcing their own fees, while failing to enforce any significant recompense to the artists themselves. It's becoming clear that the laissez-faire approach of web3 may not be the optimal solution for every context, particularly for the artists and creators who deserve fair remuneration for their efforts.

ERC721M seeks to correct these issues by enforcing mandatory royalties, offering an 'artist-first' approach that ensures consistent compensation for artists' work. It strikes a balance between the freedom offered by web3 and the practical need for fair practices in the NFT marketplace. While we acknowledge the counter-intuitive nature of our approach in the context of traditional web3 philosophy, we stand firm in our belief that this evolution is necessary to ensure a more equitable environment for artists.

We expect this restructured approach to generate a fairer NFT ecosystem, which will, in turn, draw more creators into the space, as they gain confidence in the prospect of sustainable earnings. Art collectors and investors will also be more encouraged to participate in the marketplace, knowing their purchases directly contribute to the sustenance of the artists' careers. With ERC721M, we aim to strike a new path in the NFT space, one that places a higher emphasis on respect for artist royalties and the establishment of a sustainable creative ecosystem.

## Interoperability and Value Addition
ERC721M, while introducing an integrated marketplace, does not prohibit the listing of these tokens on other external marketplaces. The intention here is to foster an environment that encourages competition and innovation, rather than creating a walled garden.

However, with the artist-first approach of ERC721M and the mandatory royalties built directly into the contract, other marketplaces will need to provide significant value-add to justify their existence and additional fees. This could involve superior user experience, additional tools for creators, marketing and promotional services, improved discoverability for artists, or any other services that enhance the overall utility of the marketplace for artists and collectors alike.

This requirement for value-add from external marketplaces represents a shift from the status quo, where the marketplaces often functioned as simple listing platforms and imposed fees without necessarily adding significant value. With the implementation of ERC721M, these platforms will have to step up, offering tangible benefits and services to both artists and collectors. The introduction of this standard will push the industry towards greater competition, improved services, and ultimately, a fairer and more beneficial environment for artists.

## Usage Instructions:

This guide provides instructions for integrating the ERC721M into your contract:
```solidity
pragma solidity ^0.8.20;

import "./ERC721M.sol";

contract MyEnforcedRoyaltiesNFT is ERC721M, Ownable {

    uint256 mintPrice = 0.08 ether;

    constructor(string memory name, string memory symbol, address payable _royaltyReceiver, uint256 _royaltyFee) ERC721M(name, symbol, _royaltyFee, _royaltyReceiver, address(this)) {}

    function mint(address to, uint256 numberOfTokens) public payable {
        require(msg.value >= (numberOfTokens * mintPrice), "Must send minimum value to mint");
        royaltyReceiver().transfer(msg.value);
        _safeMint(to, numberOfTokens, '');
    }
}
```

You can reference an example of this implementation in the provided [exampleContract.sol](https://github.com/Mirage-Gallery/ERC721M/blob/main/exampleContract.sol) file.

### Steps to Sell an NFT using ERC721M:

#### Immediate Auction Start:
```solidity
startAuction(uint256 tokenId, uint256 duration, uint256 minimumBid)
```
This function will initiate an auction that begins as soon as the transaction is confirmed.

#### Auction Start on First Bid: 
```solidity
startAuctionOnBid(uint256 tokenId, uint256 duration, uint256 minimumBid)
```
With this function, the auction will only start once the first bid has been placed.

The duration parameter for both functions is set in seconds. Please note that the ERC721M standard has a built-in minimum duration of 120 seconds, also known as a 'Rapid Auction'.

Please revise the given information and adjust as needed in your specific use case. Your successful integration of the ERC721M standard will enable efficient and secure NFT transactions.

## Important Notice on Contract Withdrawal Function:
It is often a common practice for primary sale proceeds to be sent directly to the contract. Subsequently, a withdrawal function is utilized to retrieve these funds. However, we strongly advise against employing this standard withdrawal function when using ERC721M.

The ERC721M standard functions as an escrow contract during secondary sales. Implementing a standard withdrawal function in this scenario necessitates a high level of trust from your community, as it could be perceived that you might drain the escrow. This approach might potentially erode trust and jeopardize the integrity of the transactions.

To maintain transparency and ensure the security of funds, we recommend configuring your contract to have primary sale mint funds sent directly to the royalty recipient's address. This modification ensures a safer and more trustworthy environment for your community.

You can refer to our [exampleContract.sol](https://github.com/Mirage-Gallery/ERC721M/blob/main/exampleContract.sol) for a detailed illustration of how to implement this in your contract. As always, kindly revise the provided instructions to align with your specific contract setup and use case.
