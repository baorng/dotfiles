import { describe, expect, test } from "bun:test";
import {
  readCachedWeather,
  WEATHER_CACHE_KEY,
  WEATHER_CACHE_MAX_AGE_MS,
  writeCachedWeather,
} from "./weather-cache";

const weatherOutput = {
  isDaytime: true,
  status: "clear_day",
  celsiusTemp: 30,
  fahrenheitTemp: 86,
  windSpeed: 4,
} as const;

describe("weather cache", () => {
  test("reads fresh cached weather", () => {
    const storage = new MemoryStorage();

    writeCachedWeather(weatherOutput, storage, 1000);

    expect(readCachedWeather(storage, 1000 + WEATHER_CACHE_MAX_AGE_MS - 1)).toEqual(weatherOutput);
  });

  test("drops stale cached weather", () => {
    const storage = new MemoryStorage();

    writeCachedWeather(weatherOutput, storage, 1000);

    expect(readCachedWeather(storage, 1000 + WEATHER_CACHE_MAX_AGE_MS + 1)).toBeNull();
    expect(storage.getItem(WEATHER_CACHE_KEY)).toBeNull();
  });

  test("drops invalid cached weather", () => {
    const storage = new MemoryStorage();

    storage.setItem(
      WEATHER_CACHE_KEY,
      JSON.stringify({ createdAt: 1000, weather: { status: "bad" } }),
    );

    expect(readCachedWeather(storage, 1000)).toBeNull();
    expect(storage.getItem(WEATHER_CACHE_KEY)).toBeNull();
  });
});

class MemoryStorage {
  #items = new Map<string, string>();

  getItem(key: string) {
    return this.#items.get(key) ?? null;
  }

  setItem(key: string, value: string) {
    this.#items.set(key, value);
  }

  removeItem(key: string) {
    this.#items.delete(key);
  }
}
