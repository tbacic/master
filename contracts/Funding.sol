// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Funding {
   struct DonationCampaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    mapping(uint256 => DonationCampaign) public donationCampaigns;

    uint256 public numberOfDonationCampaigns = 0;

    function createDonationCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns (uint256) {
        DonationCampaign storage donationCampaign = donationCampaigns[numberOfDonationCampaigns];

        require(donationCampaign.deadline < block.timestamp, "The deadline should be a date in the future.");

        donationCampaign.owner = _owner;
        donationCampaign.title = _title;
        donationCampaign.description = _description;
        donationCampaign.target = _target;
        donationCampaign.deadline = _deadline;
        donationCampaign.amountCollected = 0;
        donationCampaign.image = _image;

        numberOfDonationCampaigns++;

        return numberOfDonationCampaigns - 1;
    }

    function donateToDonationCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;

        DonationCampaign storage donationCampaign = donationCampaigns[_id];

        donationCampaign.donators.push(msg.sender);
        donationCampaign.donations.push(amount);

        (bool sent,) = payable(donationCampaign.owner).call{value: amount}("");

        if(sent) {
            donationCampaign.amountCollected = donationCampaign.amountCollected + amount;
        }
    }

    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        return (donationCampaigns[_id].donators, donationCampaigns[_id].donations);
    }

    function getDonationCampaigns() public view returns (DonationCampaign[] memory) {
        DonationCampaign[] memory allDonationCampaigns = new DonationCampaign[](numberOfDonationCampaigns);

        for(uint i = 0; i < numberOfDonationCampaigns; i++) {
            DonationCampaign storage item = donationCampaigns[i];

            allDonationCampaigns[i] = item;
        }

        return allDonationCampaigns;
    }
}