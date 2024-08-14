// Integration Instructions: https://docs.tenderly.co/node/integrations-smart-contract-frameworks/hardhat
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as tenderly from "@tenderly/hardhat-tenderly";
import * as dotenv from 'dotenv';

dotenv.config();
tenderly.setup({ automaticVerifications: true });

export const config: HardhatUserConfig = {
  solidity: "0.8.19",
  defaultNetwork: "tenderly",
  networks: {
    tenderly: {
      url: process.env.TNDRLY_NODE_URL,
      chainId: Number(process.env.CHAIN_ID!),
    },
  },
  tenderly: {
    username: process.env.TNDRLY_USERNAME!,
    project: process.env.TNDRLY_PROJECT!,
  },
};
