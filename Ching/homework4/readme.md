# Homework 4

## Optimising Storage

Take [this contract](https://gist.github.com/extropyCoder/6e9b5d5497b8ead54590e72382cdca24)
Use the [sol2uml tool](https://github.com/naddison36/sol2uml) to find out how many storage slots it is using.
By re ordering the variables, can you reduce the number of storage slots needed ?

Guide: https://github.com/naddison36/sol2uml

Install 

```
npm link sol2uml --only=production
```

Run

```
C:\homework4>sol2uml storage Store.sol -c Store
Generated svg file C:\homework4\Store.svg
```

60 slots occupied by Store.sol (before reordering)

![image](https://github.com/BigBangInfinity/Encode_ExpertSolidityBootcamp_Homework/assets/37957341/c1c07fb7-66ca-45bc-a70d-46a3c4978fc3)


Reordering in Store_new.sol

run 

```
\homework4>sol2uml storage Store_new.sol -c Store_new
Generated svg file C:\homework4\Store_new.svg
```

43 slots occupied

![image](https://github.com/BigBangInfinity/Encode_ExpertSolidityBootcamp_Homework/assets/37957341/23c906fb-814a-4d59-a710-0bdd203cf7af)


## Foundry introduction 

Install foundry, create default template with 

```
forge init
```

Run tests

```
$ forge test
[⠰] Compiling...
[⠘] Compiling 24 files with 0.8.21
[⠃] Solc 0.8.21 finished in 2.34s
Compiler run successful!

Ran 2 tests for test/Counter.t.sol:CounterTest
[PASS] testFuzz_SetNumber(uint256) (runs: 256, μ: 27320, ~: 28409)
[PASS] test_Increment() (gas: 28379)
Suite result: ok. 2 passed; 0 failed; 0 skipped; finished in 117.42ms (94.33ms CPU time)

Ran 1 test suite in 131.50ms (117.42ms CPU time): 2 tests passed, 0 failed, 0 skipped (2 total tests)
```


## Try out the Solidity Template or the Foundry Template

1. Start a new project using the [Solidity Template](https://github.com/PaulRBerg/hardhat-template)

2. Make a fork of mainnet from the command line (you may need to setup an Infura or Alchemy account)

```
npx hardhat node --fork https://mainnet.infura.io/v3/<API_KEY>
```

Adding 

```
  networks: {
    hardhat: {
      accounts: {
        mnemonic,
      },
      forking: {
        url: `https://mainnet.infura.io/v3/${infuraApiKey}`}
/// etc.
```

into hardhat.config.ts

3. Query the mainnet using the command line to retrieve a property such as latest block number.

```
npx hardhat console --network mainnet

>  await ethers.provider.getBlockNumber()
19339246
>  await ethers.provider.getBlockNumber()
19339247
>  await ethers.provider.getBlockNumber()
19339248
>  await ethers.provider.getBlockNumber()
19339252

```
