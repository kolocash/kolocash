import RainbowKitAndWagmiProvider from "./wagmi";
import Head from "next/head";
import { Toaster } from "@/components/ui/sonner";
import Layout from "@/components/shared/Layout";

import "./globals.css";

export const metadata = {
  title: "Kolocash",
  description: "The african crypto token",
};

export default function RootLayout({ children }) {
  return (
    <html lang="fr" suppressHydrationWarning>
      <Head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      </Head>
      <body className="bg-gradient-to-r from-slate-600 to-slate-500">
        <RainbowKitAndWagmiProvider>
          <Layout>{children}</Layout>
        </RainbowKitAndWagmiProvider>
        <Toaster />
      </body>
    </html>
  );
}
