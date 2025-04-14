"use client";

import React, { useState, useEffect, useRef } from "react";
import Link from "next/link";

type HealthStatus = {
  status: "200" | "500";
  timestamp: string;
};

export default function Page() {
  const [healthStatus, setHealthStatus] = useState<HealthStatus>({
    status: "200",
    timestamp: new Date().toISOString(),
  });
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const statusRef = useRef<"200" | "500">(healthStatus.status);

  const checkHealth = async () => {
    try {
      setIsLoading(true);
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/health`);

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      // Get the text response instead of trying to parse JSON
      const text = await response.text();
      console.log("Health check response:", text);

      const status = response.status === 200 ? "200" : "500";
      setHealthStatus({
        status,
        timestamp: new Date().toISOString(),
      });
      statusRef.current = status;
      setError(null);
    } catch (error) {
      console.error("Health check error:", error);
      setHealthStatus({
        status: "500",
        timestamp: new Date().toISOString(),
      });
      statusRef.current = "500";
      setError("Failed to fetch health status");
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    checkHealth();
    const interval = setInterval(
      checkHealth,
      statusRef.current === "200" ? 30000 : 5000
    );
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center">
      <div className="bg-white p-8 rounded-lg shadow-md w-full max-w-md">
        <div className="flex items-center justify-between mb-6">
          <h1 className="text-2xl font-bold text-gray-900">System Health</h1>
          <div className="flex space-x-4">
            <Link
              href="/profile"
              className="px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600 transition-colors"
            >
              Profiles
            </Link>
            <button
              onClick={checkHealth}
              className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition-colors"
              disabled={isLoading}
            >
              {isLoading ? "Checking..." : "Check Health"}
            </button>
          </div>
        </div>

        <div className="space-y-4">
          <div className="flex items-center space-x-3">
            <div
              className={`w-4 h-4 rounded-full ${
                healthStatus.status === "200" ? "bg-green-500" : "bg-red-500"
              }`}
            />
            <span className="text-lg font-medium">
              Status: {healthStatus.status}
            </span>
          </div>
          <div className="">Base URL: {process.env.NEXT_PUBLIC_API_URL}</div>
          {error && <div className="text-red-500 text-sm">{error}</div>}
        </div>
      </div>
    </div>
  );
}
