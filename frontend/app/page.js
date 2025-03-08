"use client";

import KolocashBalance from "@/components/KolocashBalance";
import TransferTokens from "@/components/TransferTokens";

export default function Home() {
  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
        <h2 className="text-xl font-semibold mb-4">Votre Solde KOLO</h2>
        <KolocashBalance />
      </div>

      <div className="bg-white dark:bg-gray-800 rounded-lg shadow p-6">
        <h2 className="text-xl font-semibold mb-4">Transférer des Tokens</h2>
        <TransferTokens />
      </div>

      <div className="col-span-2 bg-white dark:bg-gray-800 rounded-lg shadow p-6">
        <h2 className="text-xl font-semibold mb-4">Activité Récente</h2>
        <p className="text-gray-600 dark:text-gray-300">
          Par exemple, l'historique des transactions, la gouvernance DAO, etc.
        </p>
      </div>
    </div>
  );
}
