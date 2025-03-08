"use client";
import Link from "next/link";

export default function Aside() {
    return (
        <aside className="block w-64 bg-white dark:bg-gray-800 border-r border-gray-200 dark:border-gray-700">
            <nav className="p-6 space-y-4">
                <Link href="/" className="block text-lg font-medium hover:text-kolo-500 dark:hover:text-kolo-200">
                    Accueil
                </Link>
                <Link href="/transfer" className="block text-lg font-medium hover:text-kolo-500 dark:hover:text-kolo-200">
                    Transfert
                </Link>
                <Link href="/dao" className="block text-lg font-medium hover:text-kolo-500 dark:hover:text-kolo-200">
                    Gouvernance
                </Link>
                <Link href="/impact" className="block text-lg font-medium hover:text-kolo-500 dark:hover:text-kolo-200">
                    Impact
                </Link>
                <Link href="/settings" className="block text-lg font-medium hover:text-kolo-500 dark:hover:text-kolo-200">
                    Paramètres
                </Link>
            </nav>
        </aside>
    );
}
