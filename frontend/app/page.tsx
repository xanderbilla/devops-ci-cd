"use client";

import React, { useState, useEffect, useRef } from "react";
import Link from "next/link";
import { HealthStatus, healthApi } from "./api/healthApi";

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
      const status = await healthApi.checkHealth();
      setHealthStatus(status);
      statusRef.current = status.status;
      setError(null);
    } catch (error) {
      console.error("Health check error:", error);
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
        <h1> Test pass ;)</h1>

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
          {/* <div className="">Base URL: {process.env.NEXT_PUBLIC_API_URL}</div> */}
          {error && <div className="text-red-500 text-sm">{error}</div>}
        </div>
      </div>
    </div>
  );
}
