"use client";
import { useReadContract, useAccount } from "wagmi";
import { KOLOCASH_ADDRESS, KOLOCASH_ABI } from "@/constants";
import { formatUnits } from "ethers";

export default function KolocashBalance() {
    const { address, isConnected } = useAccount();

    const { data, isError, isLoading } = useReadContract({
        address: KOLOCASH_ADDRESS,
        abi: KOLOCASH_ABI,
        functionName: "balanceOf",
        args: [address],
        enabled: isConnected,
    });

    if (!isConnected) {
        return <p className="text-center">Veuillez connecter votre portefeuille.</p>;
    }

    if (isLoading) {
        return <p className="text-center">Chargement...</p>;
    }

    if (isError) {
        return <p className="text-center text-red-500">Erreur lors de la récupération du solde.</p>;
    }

    // Utilisation de formatUnits importé directement depuis ethers (compatible avec v6)
    const balanceFormatted = data ? formatUnits(data, 18) : "0";

    return (
        <div className="text-center">
            <p className="text-xl font-bold">{balanceFormatted} KOLO</p>
        </div>
    );
}
