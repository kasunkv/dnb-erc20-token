const DoNotBuyToken = artifacts.require("DoNotBuyToken");

module.exports = function (deployer) {
  deployer.deploy(DoNotBuyToken);
};
