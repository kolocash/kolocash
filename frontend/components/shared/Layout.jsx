"use client";

import { useState, useEffect } from "react";
import Aside from "./Aside";
import Header from "./Header";
import Footer from "./Footer";

/**
 * Le composant Layout gère la disposition générale :
 * - Sidebar (Aside) à gauche
 * - Header en haut (dans la zone centrale)
 * - Footer en bas
 * - Un toggle dark mode géré dans le Header (via un callback)
 */
export default function Layout({ children }) {
    const [darkMode, setDarkMode] = useState(false);

    // Au chargement, on vérifie la préférence stockée
    useEffect(() => {
        const stored = localStorage.getItem("kolocashDarkMode");
        if (stored === "true") {
            setDarkMode(true);
            document.documentElement.classList.add("dark");
        }
    }, []);

    // Callback pour Header : toggle du dark mode
    const handleToggleDarkMode = () => {
        if (darkMode) {
            document.documentElement.classList.remove("dark");
            localStorage.setItem("kolocashDarkMode", "false");
            setDarkMode(false);
        } else {
            document.documentElement.classList.add("dark");
            localStorage.setItem("kolocashDarkMode", "true");
            setDarkMode(true);
        }
    };

    return (
        <div className="min-h-screen flex flex-col bg-gray-50 dark:bg-gray-900 text-gray-800 dark:text-gray-100 transition-colors duration-300">
            {/* Zone supérieure + contenu en flex */}
            <div className="flex flex-1 flex-row">
                {/* Sidebar (Aside) */}
                <Aside />

                {/* Zone centrale : Header + main */}
                <div className="flex flex-col w-full">
                    <Header darkMode={darkMode} onToggleDarkMode={handleToggleDarkMode} />
                    <main className="p-6 flex-1">{children}</main>
                </div>
            </div>

            {/* Footer en bas */}
            <Footer />
        </div>
    );
}
