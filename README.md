@deca12x Day 1 Homework

1. Why is client diversity important for Ethereum?
One design but multiple implementations, means that nodes will have the same constraints, but generally work in different ways, meaning that bugs should only affect one or a subset of the client implementations, allowing the network to keep running and blocks to be produced and finalised.
A bug affecting a consensus client with 1/3 of the network can prevent finality.
A bug affecting a consensus client with 2/3 of the network can lead to a fork, stranding nodes on a wrong chain, facing slashing.

2. Where is the full Ethereum state held?
Full execution nodes hold the full state, which is made of a mapping of all ethereum addresses, to value owned, nonce, storageRoot, codeHash.
   
3. What is a replay attack ? , which 2 pieces of information can prevent it?
At a blockchain level, a malicious actor can replicate an already valid transaction from one chain to another, potentially accessing inauthorised fund or manipulating the state. The transaction could be perceived by the chain as already validated. This risk is avoided by introducing a chainID and nonce to each transaction.
At a smart contract level, it can happen if a smart contract has a custom signing scheme that is insecure. To remove the risk, it can store the account's nonce, or another smart contract identifier (e.g. hash of contract address).

4. In a contract, how do we know who called a view function?
View functions do not alter the state, so being called should not be apparent to the contract itself. They are read-only and executed on a local node.
