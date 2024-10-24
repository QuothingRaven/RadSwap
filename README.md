# Solana DEX Aggregator

A modern, efficient DEX aggregator built on Solana, featuring split routing optimization, adaptive priority fees, and a clean React-based user interface.

## Features

- 🔄 Split Order Routing: Optimizes trades by splitting orders across multiple DEXs
- 💰 Adaptive Priority Fees: Automatically adjusts fees based on network conditions
- 🔌 Multi-Wallet Support: Compatible with Phantom, Solflare, and Torus wallets
- ⚡ Gas Optimization: Includes compute budget optimization and transaction simulation
- 📊 Transaction Simulation: Pre-simulates transactions to ensure success
- 🎨 Modern UI: Clean interface built with shadcn/ui components

## Prerequisites

Before you begin, ensure you have installed:
- Node.js (v16 or higher)
- npm (v7 or higher)
- Git

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/solana-dex-aggregator.git
cd solana-dex-aggregator
```

2. Install dependencies:
```bash
npm install
```

3. Install UI components:
```bash
npx shadcn-ui@latest init
npx shadcn-ui@latest add card button input
```

## Project Structure

```
solana-dex-aggregator/
├── src/
│   ├── app/
│   │   ├── page.tsx        # Main application component
│   │   └── layout.tsx      # App layout
│   ├── lib/
│   │   └── AdvancedDexAggregator.ts  # Core DEX aggregator logic
│   └── components/
│       └── ui/             # shadcn/ui components
├── public/
├── package.json
└── README.md
```

## Dependencies

Main dependencies include:
- `@solana/web3.js`: Solana web3 utilities
- `@solana/wallet-adapter-react`: React hooks for Solana wallet integration
- `@solana/wallet-adapter-wallets`: Wallet adapters for various Solana wallets
- Next.js: React framework
- Tailwind CSS: Utility-first CSS framework
- shadcn/ui: UI component library

## Configuration

1. Environment Variables:
Create a `.env.local` file in the root directory:
```env
NEXT_PUBLIC_SOLANA_RPC_URL=your_rpc_url_here
```

2. RPC Configuration:
The app defaults to Solana's mainnet-beta cluster. To use a different cluster, modify the `endpoint` in `src/app/page.tsx`:
```typescript
const endpoint = clusterApiUrl('mainnet-beta'); // or 'devnet', 'testnet'
```

## Usage

1. Start the development server:
```bash
npm run dev
```

2. Open your browser and navigate to `http://localhost:3000`

3. Connect your Solana wallet using the "Connect Wallet" button

4. Enter the following information:
   - Input token mint address
   - Output token mint address
   - Amount to swap

5. Click "Find Routes" to see available trading routes

6. Select a route and click "Swap" to execute the trade

## Advanced Features

### Split Routes
The DEX aggregator can split orders across multiple routes to optimize for:
- Better pricing
- Reduced slippage
- Lower impact on liquidity pools

### Priority Fees
The system automatically adjusts priority fees based on:
- Recent network conditions
- Transaction complexity
- Desired confirmation time

### Gas Optimization
Includes several gas optimization features:
- Compute budget management
- Transaction simulation
- Adaptive priority fees

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Security

This project includes transaction simulation and other safety features, but please:
- Always verify transaction details before signing
- Never share private keys or seed phrases
- Be cautious with large trade amounts
- Test with small amounts first

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please:
1. Check existing GitHub issues
2. Create a new issue with detailed information about your problem
3. Join our Discord community (link coming soon)

## Acknowledgments

- Solana Foundation for the web3.js library
- shadcn for the UI components
- The Solana DEX community for inspiration and support
