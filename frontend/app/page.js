// app/page.js
import KolocashBalance from "../components/KolocashBalance";
// import TransferTokens from "../components/TransferTokens";

export default function Home() {
  return (
    <div className="space-y-12">
      {/* Message de bienvenue */}
      <section className="bg-gray-800 bg-opacity-75 rounded-lg shadow-lg p-6 max-w-3xl mx-auto">
        <h1 className="text-3xl font-bold mb-4">Bienvenue sur Kolocash</h1>
        <p className="text-lg">
          Kolocash est la monnaie crypto dédiée à l'Afrique et sa diaspora.
          Gérez vos tokens KOLO, transférez-les et suivez votre solde en temps
          réel.
        </p>
      </section>

      {/* Affichage du solde KOLO */}
      <section className="bg-gray-800 bg-opacity-75 rounded-lg shadow-lg p-6 max-w-md mx-auto">
        <h2 className="text-xl font-semibold mb-4">Votre Solde KOLO</h2>
        <KolocashBalance />
      </section>

      {/* Formulaire de transfert de tokens */}
      <section className="bg-gray-800 bg-opacity-75 rounded-lg shadow-lg p-6 max-w-md mx-auto">
        <h2 className="text-xl font-semibold mb-4">Transférer des Tokens</h2>
        {/* <TransferTokens /> */}
      </section>
    </div>
  );
}
