// SPDX-License-Identifier: GPL-3.0

//Objective:
//Only Insurance Company (Owner) verifies the Doctors
//Insurance Company sets details of all citizens 
//All citizens are having unique ids
//Doctors can only claim insurance (by using the unique id) that they will get from Insurance Company (Owner)

pragma solidity >=0.7.0 <0.9.0;

contract voting{

//Citizen Details
struct citizen{
    bool isuidgenerated;
    string name;
    uint amountInsured;
}

//address => citizen  
mapping (address=>citizen) public citizenmapping;  //"citizenmapping[address]" gives "citizen"
mapping (address=>bool) public doctormapping;

address public Owner;

constructor(){
    Owner = msg.sender;
}

modifier onlyOwner(){
require(msg.sender==Owner,"Accessible to Owner only");
_;
}

//Insurance Company Owner verifies the Doctor
function setDoctor(address _address) public onlyOwner{
 require(!doctormapping[_address],"Only Accessible to Insurance Company Owner");
 doctormapping[_address]=true;
}

//Citizen's details like name,amount insured,providing uid will be set by Insurance Company Owner
function setCitizenData(string memory _name,uint _amountInsured) public onlyOwner returns (address){
    address uid=address(uint160(uint256(keccak256(abi.encodePacked(msg.sender,block.timestamp)))));//By this we will be having different uids
    require(!citizenmapping[uid].isuidgenerated); //uid should not be generated before or uid should be generated for the first time
    citizenmapping[uid].isuidgenerated=true; //mark uid generated true
    citizenmapping[uid].name=_name;
    citizenmapping[uid].amountInsured=_amountInsured;
    return uid;
}

//Insurance will be claimed by "Doctor" after uid of citizen is provided (***Insurance Company Owner will provide the uid to doctor***)
function useInsurance(address _uid,uint _amountUsed) public returns (string memory){
    require(doctormapping[msg.sender]);//Caller must be the doctor
    require(citizenmapping[_uid].amountInsured>_amountUsed,"Insufficient Funds");//Amount Used must be lesser than Amount Insured
    //Deduct the "amount used by Doctor" from "amount Insured"
    
    citizenmapping[_uid].amountInsured -=_amountUsed;

    return "Insurance is claimed successfully";
}


}
