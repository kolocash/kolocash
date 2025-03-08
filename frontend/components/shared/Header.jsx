"use client";

import Link from "next/link";

export default function Header({ darkMode, onToggleDarkMode }) {
    return (
        <header className="bg-kolo-500 dark:bg-kolo-700 text-white px-6 py-4 shadow flex items-center justify-between">
            {/* Logo ou titre */}
            <Link href="/">
                <h1 className="text-xl font-semibold">Kolocash</h1>
            </Link>

            {/* Bouton de bascule dark mode */}
            <button
                onClick={onToggleDarkMode}
                className="bg-white/20 hover:bg-white/30 px-3 py-1 rounded transition-colors text-sm"
            >
                {darkMode ? "Mode Clair" : "Mode Sombre"}
            </button>
        </header>
    );
}
