import { API_CONFIG } from "./config";

export type HealthStatus = {
  status: "200" | "500";
  timestamp: string;
};

export const healthApi = {
  checkHealth: async (): Promise<HealthStatus> => {
    try {
      const response = await fetch(
        `${API_CONFIG.BASE_URL}${API_CONFIG.ENDPOINTS.HEALTH}`
      );
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const text = await response.text();
      console.log("Health check response:", text);

      return {
        status: response.status === 200 ? "200" : "500",
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      console.error("Health check error:", error);
      return {
        status: "500",
        timestamp: new Date().toISOString(),
      };
    }
  },
};
