// ==============================================================================
// SECTION 20: BASE MAINNET DEPLOYER & VERIFICATION SETUP SCRIPT (deploy_contracts.js)
// ==============================================================================
const { ethers } = require("hardhat");

async function main() {
  console.log("========================================================================");
  # PIPELINE STEP: INITIALIZING SYSTEM DEPLOYMENT TO BASE LAYER-2 NETWORK
  console.log("========================================================================");

  // 1. Fetch deployment account wallets from configured network parameters
  const [deployer] = await ethers.getSigners();
  console.log(`[*] Deployer Account Address: ${deployer.address}`);
  
  const balance = await ethers.provider.getBalance(deployer.address);
  console.log(`[*] Available Account Balance: ${ethers.formatEther(balance)} ETH`);

  // 2. Set up target initialization variables for your agent infrastructure
  const ownerAddress = deployer.address; 
  // Placeholder reference to pair directly with your canonical ERC-8004 Agent Card
  const erc8004CardMockAddress = "0x4A6B7b72EEdB6B3CE8c8C971dbA0d88004C99701"; 

  console.log("\n[+] Deploying SovereignAgentVault configuration parameters...");

  // 3. Compile and estimate gas parameters for the target contract factory
  const SovereignAgentVault = await ethers.getContractFactory("SovereignAgentVault");
  
  // Deploy the vault with initialization variables mapping your owner and agent addresses
  const vault = await SovereignAgentVault.deploy(ownerAddress, erc8004CardMockAddress);
  await vault.waitForDeployment();

  const deployedAddress = await vault.getAddress();
  console.log(`\n[SUCCESS] SovereignAgentVault Contract successfully deployed to Base network!`);
  console.log(`[🔗] Contract Address: ${deployedAddress}`);

  console.log("\n========================================================================");
  console.log("        VERIFICATION COMPLIANCE BLOCK GENERATED FOR BASE SCAN           ");
  console.log("========================================================================");
  console.log(`To verify your contract code manually, execute the following command:`);
  console.log(`npx hardhat verify --network base ${deployedAddress} "${ownerAddress}" "${erc8004CardMockAddress}"`);
  console.log("========================================================================");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("\n[!] Structural deployment script exception intercepted safely:");
    console.error(error);
    process.exit(1);
  });
