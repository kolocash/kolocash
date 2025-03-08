"use client";

export default function Footer() {
    return (
        <footer className="bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700 py-3 text-center">
            <p className="text-sm text-gray-500 dark:text-gray-400">
                © {new Date().getFullYear()} Kolocash. Tous droits réservés.
            </p>
        </footer>
    );
}
