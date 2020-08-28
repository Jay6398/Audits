const expenseChain = artifacts.require("expenseChain");

module.exports = function(deployer) {
  deployer.deploy(expenseChain);
};