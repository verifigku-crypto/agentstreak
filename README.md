# AgentStreak

Daily check-in streaks exclusively for Agent ID holders on BNB Chain.

Built for the **Binance Agent ID Hackathon** (Binance Wallet + BNB Chain).

## What it is

AgentStreak is a minimal daily check-in dApp. Only wallets that hold an
Agent ID (the SPACE ID ERC-721 issued by the Binance Agentic Wallet) can
check in. One check-in per UTC day. Consecutive days grow the streak;
a missed day resets it to 1.

- **No owner, no admin, no fees, no payments, no pause, no upgrade.**
- **No token, no rewards promised.** It is a streak tracker, nothing more.
- **No QR login, no session storage, no seed phrase.** Users connect their
  own wallet and confirm each check-in themselves.

## Deployed contract

- **Network:** BNB Chain (chain ID 56)
- **Contract:** [`0x65A18c130E77d8Ee67f03Ab31979DFF01ED40e44`](https://bscscan.com/address/0x65A18c130E77d8Ee67f03Ab31979DFF01ED40e44)
- **Deployment tx:** [`0xaf87f8d5b0c8b4644d04817a5f4f89c2249b39e8f3a64f36fa33ef49b51ce1c6`](https://bscscan.com/tx/0xaf87f8d5b0c8b4644d04817a5f4f89c2249b39e8f3a64f36fa33ef49b51ce1c6)
- **Block:** 134,342,178
- **Compiler:** Solidity 0.8.26, optimizer enabled, 200 runs
- **License:** MIT

## How it works

`checkIn()` requires `balanceOf(msg.sender) > 0` on the Agent ID contract
(`0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F`, SPACE ID Agent ID, ERC-721,
non-transferable). It reverts with "Agent ID required" without one, and
"Already checked in today" on a second check-in the same UTC day.

View functions:

- `getStreak(address)` — current consecutive-day streak
- `getLastCheckInDay(address)` — UTC day number of the last check-in
- `getTotalCheckIns(address)` — total check-ins of a user
- `totalCheckIns()` — total check-ins of all users

Every check-in emits `CheckIn(address indexed user, uint256 streak, uint256 day)`.

## Frontend

`frontend/index.html` is a single static page (ethers.js v6 via CDN). It
connects via `window.ethereum` on BNB Chain, shows the Agent ID status,
your streak, your last check-in and your total, and calls `checkIn()` when
you press the button (you confirm the transaction in your own wallet).
The leaderboard reads `CheckIn` events from the public RPC.

## Agent ID usage

Agent ID is used only as a gate: the contract reads `balanceOf` on the
official Agent ID contract to confirm the caller holds one. No Agent ID
data is stored, indexed, or exposed beyond the on-chain check-in events.

## License

MIT — see `LICENSE`.
