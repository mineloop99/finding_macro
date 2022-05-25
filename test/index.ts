import { expect } from "chai";
import { ethers } from "hardhat";

describe("Testing", function () {
  it("Deploy Factory", async function () {
    const Factory = await ethers.getContractFactory("Factory");
    const factory = await Factory.deploy();
    await factory.deployed();
    await factory.deployERC721(
      "TestERC721",
      "NFT"
    );
    expect(1
     ).to.equal(1);
  });
});
