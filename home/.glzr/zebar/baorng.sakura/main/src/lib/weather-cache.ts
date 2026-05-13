import type { WeatherOutput, WeatherStatus } from "zebar";

export const WEATHER_CACHE_KEY = "baorng.sakura.weather.v1";
export const WEATHER_CACHE_MAX_AGE_MS = 2 * 60 * 60 * 1000;

type WeatherCacheEntry = {
  createdAt: number;
  weather: WeatherOutput;
};

const WEATHER_STATUSES = new Set<WeatherStatus>([
  "clear_day",
  "clear_night",
  "cloudy_day",
  "cloudy_night",
  "light_rain_day",
  "light_rain_night",
  "heavy_rain_day",
  "heavy_rain_night",
  "snow_day",
  "snow_night",
  "thunder_day",
  "thunder_night",
]);

export function readCachedWeather(
  storage: Pick<Storage, "getItem" | "removeItem"> = window.localStorage,
  now = Date.now(),
): WeatherOutput | null {
  const rawEntry = storage.getItem(WEATHER_CACHE_KEY);
  if (!rawEntry) return null;

  try {
    const entry = JSON.parse(rawEntry) as Partial<WeatherCacheEntry>;
    if (
      !isFiniteNumber(entry.createdAt) ||
      now - entry.createdAt > WEATHER_CACHE_MAX_AGE_MS ||
      !isWeatherOutput(entry.weather)
    ) {
      storage.removeItem(WEATHER_CACHE_KEY);
      return null;
    }

    return entry.weather;
  } catch {
    storage.removeItem(WEATHER_CACHE_KEY);
    return null;
  }
}

export function writeCachedWeather(
  weather: WeatherOutput,
  storage: Pick<Storage, "setItem"> = window.localStorage,
  now = Date.now(),
) {
  storage.setItem(
    WEATHER_CACHE_KEY,
    JSON.stringify({
      createdAt: now,
      weather,
    } satisfies WeatherCacheEntry),
  );
}

function isWeatherOutput(value: unknown): value is WeatherOutput {
  if (!value || typeof value !== "object") return false;

  const weather = value as Partial<WeatherOutput>;
  return (
    typeof weather.isDaytime === "boolean" &&
    typeof weather.status === "string" &&
    WEATHER_STATUSES.has(weather.status as WeatherStatus) &&
    isFiniteNumber(weather.celsiusTemp) &&
    isFiniteNumber(weather.fahrenheitTemp) &&
    isFiniteNumber(weather.windSpeed)
  );
}

function isFiniteNumber(value: unknown): value is number {
  return typeof value === "number" && Number.isFinite(value);
}
