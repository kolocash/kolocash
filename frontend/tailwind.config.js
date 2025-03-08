/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: "class", // Utilisation du dark mode via la classe "dark"
  content: ["./app/**/*.{js,ts,jsx,tsx}", "./components/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      fontFamily: {
        // Optionnel, si vous souhaitez redéfinir font-sans
        sans: ["Poppins", "ui-sans-serif", "system-ui", "sans-serif"],
      },
    },
  },
  plugins: [],
};
