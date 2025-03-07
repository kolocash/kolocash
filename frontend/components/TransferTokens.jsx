"use client";
import { useState } from "react";
import { useAccount, usePrepareContractWrite, useContractWrite } from "wagmi";
import { KOLOCASH_ADDRESS, KOLOCASH_ABI } from "@/constants";

export default function TransferTokens() {
    const { address, isConnected } = useAccount();
    const [recipient, setRecipient] = useState("");
    const [amount, setAmount] = useState("");

    // Préparation de l'appel à la fonction "transfer"
    const { config, error: prepareError } = usePrepareContractWrite({
        address: KOLOCASH_ADDRESS,
        abi: KOLOCASH_ABI,
        functionName: "transfer",
        args: [recipient, amount],
        enabled: isConnected && recipient !== "" && amount !== "",
    });

    const { data, error, isLoading, write } = useContractWrite(config);

    const handleSubmit = (e) => {
        e.preventDefault();
        if (write) {
            write();
        }
    };

    if (!isConnected) {
        return <p className="text-center">Veuillez connecter votre portefeuille pour transférer des tokens.</p>;
    }

    return (
        <form onSubmit={handleSubmit} className="space-y-4">
            <div>
                <label className="block text-sm font-medium">Adresse du destinataire</label>
                <input
                    type="text"
                    value={recipient}
                    onChange={(e) => setRecipient(e.target.value)}
                    placeholder="0x..."
                    className="mt-1 block w-full rounded border-gray-300 shadow-sm focus:ring-indigo-500 focus:border-indigo-500"
                    required
                />
            </div>
            <div>
                <label className="block text-sm font-medium">Montant à transférer (en wei)</label>
                <input
                    type="number"
                    value={amount}
                    onChange={(e) => setAmount(e.target.value)}
                    placeholder="Montant en wei"
                    className="mt-1 block w-full rounded border-gray-300 shadow-sm focus:ring-indigo-500 focus:border-indigo-500"
                    required
                />
            </div>
            {prepareError && (
                <p className="text-sm text-red-500">
                    Erreur de préparation : {prepareError.message}
                </p>
            )}
            {error && (
                <p className="text-sm text-red-500">
                    Erreur de transaction : {error.message}
                </p>
            )}
            <button
                type="submit"
                disabled={isLoading || !write}
                className="w-full py-2 px-4 rounded bg-indigo-600 text-white hover:bg-indigo-700 disabled:opacity-50"
            >
                {isLoading ? "Transfert en cours..." : "Transférer"}
            </button>
            {data && (
                <p className="text-sm text-green-500">
                    Transaction envoyée ! Hash: {data.hash}
                </p>
            )}
        </form>
    );
}
