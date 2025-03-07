"use client";
import { useContractRead, useAccount } from "wagmi";
import { KOLOCASH_ADDRESS, KOLOCASH_ABI } from "@/constants";
import { ethers } from "ethers";

export default function KolocashBalance() {
    const { address, isConnected } = useAccount();

    const { data, isError, isLoading } = useContractRead({
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

    // Convertir le solde (BigNumber) en format lisible (en KOLO, avec 18 décimales)
    const balanceFormatted = data ? ethers.utils.formatUnits(data, 18) : "0";

    return (
        <div className="text-center">
            <p className="text-xl font-bold">{balanceFormatted} KOLO</p>
        </div>
    );
}
