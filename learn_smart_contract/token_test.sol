pragma solidity >0.4.16;

contract OwnedToken {
   // TokenCreator 是如下定义的合约类型.
   // 不创建新合约的话，也可以引用它。
   TokenCreator creator;
   address owner;
   bytes32 name;

   // 这是注册 creator 和分配名称的构造函数。
    constructor(bytes32 _name) public {
       // 状态变量通过其名称访问，而不是通过例如 this.owner.
       // 这也适用于函数，特别是在构造函数中，你只能那样调用他们（"内部调用"），
       // 因为合约本身还不存在。
       owner = msg.sender;
       // 从 `address` 到 `TokenCreator` ，我们做显式的类型转换
       // 并且假定调用合约的类型是 TokenCreator，没有真正的检查方法。
       creator = TokenCreator(msg.sender);
       name = _name;
   }

   function changeName(bytes32 newName) public {
       // 只有 creator 能够更改名称 -- 因为合约是隐式转换为地址的，
       // 所以这里的比较是可能的。
       if (msg.sender == address(creator))
           name = newName;
   }

   function transfer(address newOwner) public {
       // 只有当前所有者才能传送权证
       if (msg.sender != owner) return;
       // 我们还想确认 creator 是否权证转移是正常操作。
       // 请注意，这里调用了一个下面定义的合约中的函数。
       // 如果调用失败（比如，由于 gas 不足），会立即停止执行。
    //   if (creator.isTokenTransferOK(owner, newOwner))
    //       owner = newOwner;
   }
}

contract TokenCreator {
   function createToken(bytes32 name)
      public
      returns (OwnedToken tokenAddress)
   {
       // 创建一个新的权证合约并且返回它的地址。
       // 从 JavaScript 方面来说，返回类型是简单的 `address` 类型，这是因为
       // 这是在 ABI 中最接近的类型。
       return new OwnedToken(name);
   }

   function changeName(OwnedToken tokenAddress, bytes32 name)  public {
       // 同样，`tokenAddress` 的外部类型也是 `address` 。
       tokenAddress.changeName(name);
   }

//   function isTokenTransferOK(address currentOwner, address newOwner)
//       public
//       view
//       returns (bool ok)
//   {
//       // 检查一些任意的情况。
//       address tokenAddress = msg.sender;
//       return (keccak256(newOwner) & 0xff) == (bytes20(tokenAddress) & 0xff);
//   }
}