const fs = require('fs');

module.exports = {
  export(contractName, jsonAddress, file) {
    fs.writeFile(file, JSON.stringify({contract: contractName, address: jsonAddress}), function(err) {
      if(err) {
        return console.log(err);
      }
      console.log("wrote address to file");
    });
  }
};