import React, { useState, useEffect } from 'react';
import { WalletMultiButton } from '@solana/wallet-adapter-react-ui';
import { useWallet, useConnection } from '@solana/wallet-adapter-react';
import {
    ConnectionProvider,
    WalletProvider,
} from '@solana/wallet-adapter-react';
import {
    PhantomWalletAdapter,
    SolflareWalletAdapter,
    TorusWalletAdapter,
} from '@solana/wallet-adapter-wallets';
import { clusterApiUrl, PublicKey } from '@solana/web3.js';
import { Card, CardHeader, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import AdvancedDexAggregator from './AdvancedDexAggregator';

require('@solana/wallet-adapter-react-ui/styles.css');

const App = () => {
    // You can also provide your own RPC endpoint
    const endpoint = clusterApiUrl('mainnet-beta');
    const wallets = [
        new PhantomWalletAdapter(),
        new SolflareWalletAdapter(),
        new TorusWalletAdapter(),
    ];

    return (
        <ConnectionProvider endpoint={endpoint}>
            <WalletProvider wallets={wallets} autoConnect>
                <div className="min-h-screen bg-gray-100">
                    <DexAggregatorContent />
                </div>
            </WalletProvider>
        </ConnectionProvider>
    );
};

const DexAggregatorContent = () => {
    const { wallet, publicKey, connected } = useWallet();
    const { connection } = useConnection();
    const [inputMint, setInputMint] = useState('');
    const [outputMint, setOutputMint] = useState('');
    const [amount, setAmount] = useState('');
    const [routes, setRoutes] = useState([]);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');

    const dexAggregator = new AdvancedDexAggregator(connection.rpcEndpoint);

    const handleFindRoutes = async () => {
        if (!connected) {
            setError('Please connect your wallet first');
            return;
        }

        if (!inputMint || !outputMint || !amount) {
            setError('Please fill in all fields');
            return;
        }

        setLoading(true);
        setError('');

        try {
            const routes = await dexAggregator.findOptimalSplitRoutes(
                new PublicKey(inputMint),
                new PublicKey(outputMint),
                BigInt(amount),
                3, // maxHops
                3  // maxSplits
            );
            setRoutes(routes);
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };

    const handleSwap = async (route) => {
        if (!connected) {
            setError('Please connect your wallet first');
            return;
        }

        setLoading(true);
        setError('');

        try {
            const transactions = await dexAggregator.executeOptimizedSwap(
                [route],
                publicKey,
                {
                    simulateFirst: true,
                    targetConfirmationTime: 0.5
                }
            );

            for (const transaction of transactions) {
                // Sign and send each transaction
                const signature = await wallet.sendTransaction(
                    transaction,
                    connection
                );
                await connection.confirmTransaction(signature);
            }
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="container mx-auto px-4 py-8">
            <Card className="mb-8">
                <CardHeader>
                    <div className="flex justify-between items-center">
                        <h1 className="text-2xl font-bold">Solana DEX Aggregator</h1>
                        <WalletMultiButton />
                    </div>
                </CardHeader>
                <CardContent>
                    <div className="space-y-4">
                        <div>
                            <label className="block text-sm font-medium mb-1">Input Token Mint</label>
                            <Input
                                type="text"
                                value={inputMint}
                                onChange={(e) => setInputMint(e.target.value)}
                                placeholder="Enter input token mint address"
                                className="w-full"
                            />
                        </div>
                        
                        <div>
                            <label className="block text-sm font-medium mb-1">Output Token Mint</label>
                            <Input
                                type="text"
                                value={outputMint}
                                onChange={(e) => setOutputMint(e.target.value)}
                                placeholder="Enter output token mint address"
                                className="w-full"
                            />
                        </div>

                        <div>
                            <label className="block text-sm font-medium mb-1">Amount</label>
                            <Input
                                type="number"
                                value={amount}
                                onChange={(e) => setAmount(e.target.value)}
                                placeholder="Enter amount"
                                className="w-full"
                            />
                        </div>

                        <Button
                            onClick={handleFindRoutes}
                            disabled={loading || !connected}
                            className="w-full"
                        >
                            {loading ? 'Finding routes...' : 'Find Routes'}
                        </Button>

                        {error && (
                            <div className="text-red-500 text-sm">{error}</div>
                        )}
                    </div>
                </CardContent>
            </Card>

            {routes.length > 0 && (
                <Card>
                    <CardHeader>
                        <h2 className="text-xl font-bold">Available Routes</h2>
                    </CardHeader>
                    <CardContent>
                        <div className="space-y-4">
                            {routes.map((route, index) => (
                                <div key={index} className="border p-4 rounded-lg">
                                    <div className="flex justify-between items-center">
                                        <div>
                                            <p className="font-medium">Split {index + 1}</p>
                                            <p className="text-sm text-gray-600">
                                                Percentage: {route.percentage}%
                                            </p>
                                            <p className="text-sm text-gray-600">
                                                Expected Output: {route.expectedOutputAmount.toString()}
                                            </p>
                                            {route.priorityFee && (
                                                <p className="text-sm text-gray-600">
                                                    Priority Fee: {route.priorityFee} SOL
                                                </p>
                                            )}
                                        </div>
                                        <Button
                                            onClick={() => handleSwap(route)}
                                            disabled={loading}
                                            variant="secondary"
                                        >
                                            Swap
                                        </Button>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </CardContent>
                </Card>
            )}
        </div>
    );
};

export default App;
