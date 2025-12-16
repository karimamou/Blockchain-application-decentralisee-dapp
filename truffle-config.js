module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",
    },
  },
  contracts_build_directory: "./src/artifacts/",

  compilers: {
    solc: {
      version: "0.8.19",      // <--- ON MET 0.8.19 ICI (Plus stable pour Ganache)
      optimizer: {
        enabled: false,
        runs: 200
      }
    }
  }
};