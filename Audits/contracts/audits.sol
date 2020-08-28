pragma solidity >=0.4.21 <0.6.0;

contract expenseChain {
   
    uint32 public expense_id = 0; // Product ID
    uint32 public participant_id = 0; // Participant ID
   
   
    constructor() public{
        participant_id++;
        participants[participant_id].userName="Admin";
        participants[participant_id].password="Admin Password";
        participants[participant_id].participantType="Admin";
        participants[participant_id].participantAddress=msg.sender;
        participants[participant_id].rights=true;
    }
   
    modifier onlyOwner(uint32 userId){
        require(participants[userId].rights==true);
        _;
    }

    struct expense {
        string name;
        string expense_purpose;
        address expense_Owner;
        uint32 cost;
        uint32 mfgTimeStamp;
    }
   
    mapping(uint32 => expense) public exp;
   
    struct participant {
        string userName;
        string password;
        string participantType;
        address participantAddress;
        bool rights;
    }
   
    mapping(uint32 => participant) public participants;
    mapping(uint32 => uint32[]) public expenseTrack; 
    event TransferOwnership(uint32 productId);
   
    function giveRights(uint32 owId,uint32 userId) public onlyOwner(owId) returns(bool){
        participants[userId].rights=true;
    }

    function revokeRights(uint32 owId,uint32 userId) public onlyOwner(owId) returns(bool){
            participants[userId].rights=false;
    }
   
    function addParticipant(string memory _name, string memory _pass, address _pAdd, string memory _pType) public returns (uint32){
        uint32 userId = ++participant_id;
        participants[userId].userName = _name;
        participants[userId].password = _pass;
        participants[userId].participantAddress = _pAdd;
        participants[userId].participantType = _pType;
        return userId;
    }
   
    function getParticipant(uint32 _participant_id) public view returns (string memory,address,string memory) {
        return (participants[_participant_id].userName,
        participants[_participant_id].participantAddress,
        participants[_participant_id].participantType);
    }
   
    function addExpense(uint32 _ownerId,string memory _name, string memory _purpose, uint32 _Cost) public returns (uint32) {
        if(keccak256(abi.encodePacked(participants[_ownerId].rights)) == keccak256(abi.encodePacked(true))) {
            uint32 expId = ++expense_id;
            exp[expId].name = _name;
            exp[expId].expense_purpose = _purpose;
            exp[expId].cost = _Cost;
            exp[expId].expense_Owner = participants[_ownerId].participantAddress;
            exp[expId].mfgTimeStamp = uint32(now);
            expenseTrack[_ownerId].push(expId);
        }
        return 0;
    }

   
    function getExpense(uint32 _expId) public view returns (string memory,string memory,uint32,address,uint32){
        return (exp[_expId].name,
        exp[_expId].expense_purpose,
        exp[_expId].cost,
        exp[_expId].expense_Owner,
        exp[_expId].mfgTimeStamp);
    }
    
    function getProvenance(uint32 par) external view returns (uint32[] memory) {
        if(keccak256(abi.encodePacked(participants[par].rights)) == keccak256(abi.encodePacked(true))){
            return expenseTrack[par];
        }
}


   
    function authenticateParticipant(uint32 _uid, string memory _uname,string memory _pass, string memory _utype) public view returns (bool){
        if(keccak256(abi.encodePacked(participants[_uid].participantType)) == keccak256(abi.encodePacked(_utype))) {
            if(keccak256(abi.encodePacked(participants[_uid].userName)) == keccak256(abi.encodePacked(_uname))) {
                if(keccak256(abi.encodePacked(participants[_uid].password)) == keccak256(abi.encodePacked(_pass))) {
                    return (true);
                }
            }
        }
        return (false);
    }
}

