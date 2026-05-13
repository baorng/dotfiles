import type { WeatherStatus } from "zebar";
import { SCREEN_SAFE_AREAS } from "../screen-safe-areas";

const NOTCHED_MACBOOK_MONITOR_NAMES = /built.?in|color lcd|liquid retina|retina|macbook/i;
const NOTCHED_MACBOOK_ASPECT_MIN = 1.52;
const NOTCHED_MACBOOK_ASPECT_MAX = 1.56;
const NOTCHED_MACBOOK_MIN_WIDTH = 1300;
const NOTCHED_MACBOOK_MAX_WIDTH = 3600;
const NOTCH_MARGIN = 6;

type Rect = {
  x: number;
  y: number;
  width: number;
  height: number;
};

type ScreenSafeArea = {
  name: string;
  frame: Rect;
  auxiliaryTopLeftArea: Rect | null;
  auxiliaryTopRightArea: Rect | null;
};

export type MonitorLike = {
  name?: string | null;
  deviceName?: string | null;
  width?: number | null;
  height?: number | null;
  size?: {
    width?: number | null;
    height?: number | null;
  } | null;
};

export type WorkspaceLike = {
  hasFocus?: boolean;
  name?: string | null;
};

const WEATHER_MAP_NAME: Record<WeatherStatus, string> = {
  cloudy_day: "Cloudy Day",
  cloudy_night: "Cloudy Night",
  heavy_rain_day: "Rainy Day",
  heavy_rain_night: "Rainy Night",
  light_rain_day: "Slightly Rainy Day",
  light_rain_night: "Slightly Rainy Night",
  snow_day: "Snowy Day",
  snow_night: "Snowy Night",
  thunder_day: "Stormy Day",
  thunder_night: "Stormy Night",
  clear_day: "Clear Day",
  clear_night: "Clear Night",
};

export function isFocusedWorkspace(
  workspace: WorkspaceLike,
  focusedWorkspace: WorkspaceLike | undefined,
): boolean {
  return workspace.hasFocus === true || workspace === focusedWorkspace;
}

export function formatBatteryCharge(chargePercent: number): string {
  return Math.round(chargePercent).toString();
}

export function batteryFillWidth(chargePercent: number): number {
  const clampedCharge = Math.min(100, Math.max(0, chargePercent));
  return 13 * (clampedCharge / 100);
}

export function getWeatherName(weatherStatus: WeatherStatus): string {
  return WEATHER_MAP_NAME[weatherStatus];
}

export function getNotchCssVariables(monitor: MonitorLike | undefined): string | undefined {
  const bounds = getNotchBounds(monitor);
  if (!bounds) return undefined;

  return `--notch-left: ${bounds.left}px; --notch-right: ${bounds.right}px; --notch-margin: ${NOTCH_MARGIN}px;`;
}

export function shouldDodgeNotch(monitor: MonitorLike | undefined): boolean {
  return getNotchBounds(monitor) !== null;
}

function getNotchBounds(monitor: MonitorLike | undefined): { left: number; right: number } | null {
  const screen = getMatchingScreenSafeArea(monitor);
  if (!screen?.auxiliaryTopLeftArea || !screen.auxiliaryTopRightArea) {
    return null;
  }

  const left =
    screen.auxiliaryTopLeftArea.x + screen.auxiliaryTopLeftArea.width - screen.frame.x;
  const right = screen.auxiliaryTopRightArea.x - screen.frame.x;
  if (right <= left) return null;

  return { left, right };
}

function getMatchingScreenSafeArea(
  monitor: MonitorLike | undefined,
): ScreenSafeArea | undefined {
  if (!monitor || !shouldCheckForNotch(monitor)) return undefined;

  const monitorName = getMonitorName(monitor);
  const width = getMonitorWidth(monitor);
  const height = getMonitorHeight(monitor);

  return SCREEN_SAFE_AREAS.find((screen) => {
    const nameMatches = screen.name === monitorName;
    const sizeMatches = screen.frame.width === width && screen.frame.height === height;
    return nameMatches || sizeMatches;
  }) as ScreenSafeArea | undefined;
}

function shouldCheckForNotch(monitor: MonitorLike): boolean {
  if (NOTCHED_MACBOOK_MONITOR_NAMES.test(getMonitorName(monitor))) return true;

  const width = getMonitorWidth(monitor);
  const height = getMonitorHeight(monitor);
  if (!Number.isFinite(width) || !Number.isFinite(height) || height === 0) {
    return false;
  }

  const aspectRatio = width / height;
  return (
    width >= NOTCHED_MACBOOK_MIN_WIDTH &&
    width <= NOTCHED_MACBOOK_MAX_WIDTH &&
    aspectRatio >= NOTCHED_MACBOOK_ASPECT_MIN &&
    aspectRatio <= NOTCHED_MACBOOK_ASPECT_MAX
  );
}

function getMonitorName(monitor: MonitorLike): string {
  return String(monitor.name ?? monitor.deviceName ?? "");
}

function getMonitorWidth(monitor: MonitorLike): number {
  return Number(monitor.width ?? monitor.size?.width);
}

function getMonitorHeight(monitor: MonitorLike): number {
  return Number(monitor.height ?? monitor.size?.height);
}
