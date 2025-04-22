"use client";

import React, { useState, useEffect } from "react";
import { Person, personApi } from "../api/personApi";

export default function ProfilePage() {
  const [persons, setPersons] = useState<Person[]>([]);
  const [newPerson, setNewPerson] = useState<Person>({ name: "", age: 0 });
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchPersons = async () => {
    try {
      const data = await personApi.getAllPersons();
      setPersons(data);
      setError(null);
    } catch (error) {
      console.error("Error fetching persons:", error);
      setError("Failed to fetch persons");
    } finally {
      setIsLoading(false);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await personApi.createPerson(newPerson);
      // Reset form and refresh the list
      setNewPerson({ name: "", age: 0 });
      fetchPersons();
    } catch (error) {
      console.error("Error creating person:", error);
      setError("Failed to create person");
    }
  };

  useEffect(() => {
    fetchPersons();
  }, []);

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-4xl mx-auto px-4">
        <div className="bg-white rounded-lg shadow-md p-6 mb-6">
          <h1 className="text-2xl font-bold text-gray-900 mb-6">
            Create Profile
          </h1>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label
                htmlFor="name"
                className="block text-sm font-medium text-gray-700"
              >
                Name
              </label>
              <input
                type="text"
                id="name"
                value={newPerson.name}
                onChange={(e) =>
                  setNewPerson({ ...newPerson, name: e.target.value })
                }
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                required
              />
            </div>
            <div>
              <label
                htmlFor="age"
                className="block text-sm font-medium text-gray-700"
              >
                Age
              </label>
              <input
                type="number"
                id="age"
                value={newPerson.age}
                onChange={(e) =>
                  setNewPerson({ ...newPerson, age: parseInt(e.target.value) })
                }
                className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
                required
              />
            </div>
            <button
              type="submit"
              className="w-full bg-blue-500 text-white py-2 px-4 rounded-md hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
            >
              Create Profile
            </button>
          </form>
        </div>

        <div className="bg-white rounded-lg shadow-md p-6">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Profiles</h2>
          {isLoading ? (
            <p className="text-gray-500">Loading profiles...</p>
          ) : error ? (
            <p className="text-red-500">{error}</p>
          ) : (
            <div className="space-y-4">
              {persons.map((person, index) => (
                <div
                  key={index}
                  className="border rounded-lg p-4 hover:bg-gray-50 transition-colors"
                >
                  <h3 className="text-lg font-medium text-gray-900">
                    {person.name}
                  </h3>
                  <p className="text-gray-500">Age: {person.age}</p>
                </div>
              ))}
              {persons.length === 0 && (
                <p className="text-gray-500">No profiles found</p>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
