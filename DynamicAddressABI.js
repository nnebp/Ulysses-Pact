// This file does two things to avoid copy + pasting a new contract address in the front-end every time we update it.
// 1. It will be called from the truffle tests to write out a newly deployed contracts address to a json file.
// 2. It will be called in the browser to get the address.

const fs = require('fs');
const express = require('express');
const app = express();
const port = 3000;

//TODO get the abi this way too
module.exports = {
  save(contractName, address, file, buildFile) {//todo need to change address var name?
    const abiJson = JSON.parse(fs.readFileSync(buildFile, 'utf8'));
    fs.writeFile(file, JSON.stringify({contract: contractName, address: address, abi: abiJson.abi}), function(err) {
      if(err) {
        return console.log(err);
      }
      console.log("wrote address to file");
    });
  }
};

// Deal with CORS nonsense
app.all('/*', function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "X-Requested-With");
  next();
});

// Send the json
app.get('/address', (req, res) => res.sendFile('address.json' , { root : __dirname}));

app.listen(port);
