"use client";
import "@rainbow-me/rainbowkit/styles.css";

import { getDefaultConfig, RainbowKitProvider } from "@rainbow-me/rainbowkit";
import { WagmiProvider } from "wagmi";
import { polygon, polygonAmoy, bsc } from "wagmi/chains"; // import { sepolia } from "@/utils/sepolia";
import { QueryClientProvider, QueryClient } from "@tanstack/react-query";

const config = getDefaultConfig({
  appName: "Kolocash",
  projectId: "90ae2f07102b598351ba0d2da46093fe", // Identifiant CloudWallet (https://cloud.walletconnect.com/)
  chains: [polygonAmoy, polygon, bsc],
  ssr: true,
});

const queryClient = new QueryClient();

const RainbowKitAndWagmiProvider = ({ children }) => {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <RainbowKitProvider>{children}</RainbowKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
};

export default RainbowKitAndWagmiProvider;
