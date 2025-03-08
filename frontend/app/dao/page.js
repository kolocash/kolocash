"use client";

export default function DAOPage() {
  // Exemple de données fictives pour les propositions DAO
  const proposals = [
    {
      id: 1,
      title: "Augmenter la taxe de transfert",
      status: "Active",
      votes: 1250,
      date: "2025-03-05",
    },
    {
      id: 2,
      title: "Déployer un nouveau pool de liquidités",
      status: "Pending",
      votes: 980,
      date: "2025-03-06",
    },
    {
      id: 3,
      title: "Modifier les adresses de wallet",
      status: "Completed",
      votes: 1420,
      date: "2025-03-04",
    },
  ];

  // Fonction pour déterminer les classes de style selon le statut
  const getStatusClasses = (status) => {
    switch (status) {
      case "Active":
        return "bg-blue-100 text-blue-800";
      case "Pending":
        return "bg-yellow-100 text-yellow-800";
      case "Completed":
        return "bg-green-100 text-green-800";
      default:
        return "bg-gray-100 text-gray-800";
    }
  };

  return (
    <div className="p-6">
      {/* En-tête de la page DAO */}
      <div className="mb-6 flex justify-between items-center">
        <h1 className="text-3xl font-bold">Gouvernance DAO Kolocash</h1>
        <button className="px-4 py-2 bg-primary text-white rounded-md hover:bg-primary-dark transition">
          Créer une proposition
        </button>
      </div>

      {/* Tableau des propositions */}
      <div className="bg-white dark:bg-gray-800 shadow rounded-lg overflow-hidden">
        <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
          <thead className="bg-gray-50 dark:bg-gray-700">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                ID
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Titre
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Statut
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Votes
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Date
              </th>
            </tr>
          </thead>
          <tbody className="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
            {proposals.map((proposal) => (
              <tr key={proposal.id}>
                <td className="px-6 py-4 whitespace-nowrap">{proposal.id}</td>
                <td className="px-6 py-4 whitespace-nowrap">
                  {proposal.title}
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  <span
                    className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${getStatusClasses(
                      proposal.status
                    )}`}
                  >
                    {proposal.status}
                  </span>
                </td>
                <td className="px-6 py-4 whitespace-nowrap">
                  {proposal.votes}
                </td>
                <td className="px-6 py-4 whitespace-nowrap">{proposal.date}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
