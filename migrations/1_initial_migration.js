var Migrations = artifacts.require("./Migrations.sol");
var Up = artifacts.require("Up");
var UpFactory = artifacts.require("UpFactory");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Up);
  deployer.deploy(UpFactory);
};


