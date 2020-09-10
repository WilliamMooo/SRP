pragma solidity >0.4.0;

contract HellowWorld {
    string str = "hello world!";
    
    function showStr() public view returns(string memory) {
        return str;
    }
    
    function changeStr(string memory newStr) public {
        str = newStr;
    }
    
}