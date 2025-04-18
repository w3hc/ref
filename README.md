# Ref

A minimalist on-chain referral tracking system.

- Demo referral link: **https://genji-app.netlify.app/referral/0x3e50d7faf96b4294367cc3563b55cbd02bb4ce4d**
- UI repo: https://github.com/w3hc/genji

## Overview

This contract allows tracking referral relationships between addresses. Any address can register a referrer-referee
relationship.

## Features

- Register referrer-referee relationships
- Track referral counts per address
- Query all referrals made by an address
- Get total registered users

## Development

```bash
# Install dependencies
bun install

# Compile
forge build

# Test
forge test

# Deploy locally
forge script script/Deploy.s.sol --broadcast --fork-url http://localhost:8545
```

## Deployment

Update your `.env` file with your configuration:

```bash
cp .env.example .env
# Edit .env with your own keys
```

```bash
forge script script/Deploy.s.sol --rpc-url op_sepolia --private-key <YOUR_PRIVATE_KEY> --broadcast --verify
```

Example deployment to OP Sepolia:
https://sepolia-optimism.etherscan.io/address/0x03917205bfef0692fae6e26dd87fcc7f96123af2#code

## Support

Feel free to reach out to [Julien](https://github.com/julienbrg) on [Farcaster](https://warpcast.com/julien-),
[Element](https://matrix.to/#/@julienbrg:matrix.org),
[Status](https://status.app/u/iwSACggKBkp1bGllbgM=#zQ3shmh1sbvE6qrGotuyNQB22XU5jTrZ2HFC8bA56d5kTS2fy),
[Telegram](https://t.me/julienbrg), [Twitter](https://twitter.com/julienbrg),
[Discord](https://discordapp.com/users/julienbrg), or [LinkedIn](https://www.linkedin.com/in/julienberanger/).

## License

This project is licensed under the GNU General Public License v3.0.

<img src="https://bafkreid5xwxz4bed67bxb2wjmwsec4uhlcjviwy7pkzwoyu5oesjd3sp64.ipfs.w3s.link" alt="built-with-ethereum-w3hc" width="100"/>
