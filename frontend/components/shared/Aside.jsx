"use client";
import Link from "next/link";
import { useState } from "react";

// Import des icônes Heroicons
import {
    HomeIcon,
    ClipboardDocumentListIcon,
    ArrowUpOnSquareIcon,
    CurrencyDollarIcon,
    Cog6ToothIcon,
} from "@heroicons/react/24/outline";

export default function Aside() {
    const [mode, setMode] = useState("user");

    const toggleMode = () => {
        setMode((prev) => (prev === "user" ? "operator" : "user"));
    };

    return (
        <aside className="w-60 text-white flex flex-col border-r border-gray-200">
            {/* Titre du projet */}
            <div className="mb-6 p-4">
                <h1 className="text-2xl font-bold">Kolocash</h1>
            </div>

            {/* Menu principal */}
            <nav className="flex-1">
                <ul className="space-y-2">
                    <li>
                        <Link href="/" className="flex items-center p-3 hover:bg-gray-700">
                            <HomeIcon className="w-5 h-5 mr-2 shrink-0" />
                            Accueil
                        </Link>
                    </li>
                    <li>
                        <Link href="/missions" className="flex items-center p-3 hover:bg-gray-700">
                            <ClipboardDocumentListIcon className="w-5 h-5 mr-2 shrink-0" />
                            Missions
                        </Link>
                    </li>
                    <li>
                        <Link href="/transfer" className="flex items-center p-3 hover:bg-gray-700">
                            <ArrowUpOnSquareIcon className="w-5 h-5 mr-2 shrink-0" />
                            Transfert
                        </Link>
                    </li>
                    <li>
                        <Link href="/exchange" className="flex items-center p-3 hover:bg-gray-700">
                            <CurrencyDollarIcon className="w-5 h-5 mr-2 shrink-0" />
                            Achat/Vente
                        </Link>
                    </li>
                    <li>
                        <Link href="/dao" className="flex items-center p-3 hover:bg-gray-700">
                            <ClipboardDocumentListIcon className="w-5 h-5 mr-2 shrink-0" />
                            Gouvernance
                        </Link>
                    </li>
                </ul>
            </nav>

            {/* Zone de configuration */}
            <div className="mt-4 px-3 pb-5">
                <div className="flex items-center justify-between mb-2">
                    <span className="text-sm">
                        {mode === "user" ? "Mode Utilisateur" : "Mode Opérateur"}
                    </span>
                    <label className="relative inline-flex items-center cursor-pointer">
                        <input
                            type="checkbox"
                            className="sr-only peer"
                            checked={mode === "operator"}
                            onChange={toggleMode}
                        />
                        <div
                            className="w-10 h-5 bg-gray-200 peer-focus:outline-none dark:bg-gray-700 peer-checked:bg-indigo-600
                         relative rounded-full after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white 
                         after:border-gray-300 after:border after:rounded-full after:h-4 after:w-4 
                         after:transition-all peer-checked:after:translate-x-full peer-checked:after:border-white"
                        ></div>
                    </label>
                </div>

                <Link
                    className="flex items-center text-sm p-3 hover:bg-gray-700"
                    href="/settings"
                >
                    <Cog6ToothIcon className="w-5 h-5 mr-2 shrink-0" />
                    Paramètres
                </Link>

                {/* Affichage conditionnel du lien Admin uniquement en mode opérateur */}
                {mode === "operator" && (
                    <Link
                        className="flex items-center text-sm p-3 hover:bg-gray-700"
                        href="/admin"
                    >
                        <svg
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            strokeWidth={1.5}
                            stroke="currentColor"
                            className="w-5 h-5 mr-2 shrink-0"
                        >
                            <path
                                strokeLinecap="round"
                                strokeLinejoin="round"
                                d="m6.75 7.5 3 2.25-3 2.25m4.5 0h3m-9 8.25h13.5A2.25 2.25 0 0 0 21 18V6a2.25 2.25 0 0 0-2.25-2.25H5.25A2.25 2.25 0 0 0 3 6v12a2.25 2.25 0 0 0 2.25 2.25Z"
                            />
                        </svg>
                        Admin
                    </Link>
                )}
            </div>
        </aside>
    );
}
