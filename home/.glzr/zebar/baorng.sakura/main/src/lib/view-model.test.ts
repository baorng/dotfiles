import { describe, expect, test } from "bun:test";
import {
  batteryFillWidth,
  formatBatteryCharge,
  getNotchCssVariables,
  getWeatherName,
  isFocusedWorkspace,
  shouldDodgeNotch,
  toLogicalMonitor,
} from "./view-model";

describe("view model helpers", () => {
  test("formats battery charge as the rounded visible percentage", () => {
    expect(formatBatteryCharge(76.2)).toBe("76");
    expect(formatBatteryCharge(76.8)).toBe("77");
  });

  test("clamps battery fill width to the icon interior", () => {
    expect(batteryFillWidth(-10)).toBe(0);
    expect(batteryFillWidth(50)).toBe(6.5);
    expect(batteryFillWidth(110)).toBe(13);
  });

  test("matches focused workspace by GlazeWM focus flag or identity", () => {
    const focusedWorkspace = { name: "2" };

    expect(isFocusedWorkspace(focusedWorkspace, focusedWorkspace)).toBe(true);
    expect(isFocusedWorkspace({ name: "2", hasFocus: true }, undefined)).toBe(true);
    expect(isFocusedWorkspace({ name: "2" }, focusedWorkspace)).toBe(false);
    expect(isFocusedWorkspace({ name: "3" }, focusedWorkspace)).toBe(false);
  });

  test("returns Sakura weather labels", () => {
    expect(getWeatherName("clear_day")).toBe("Clear Day");
    expect(getWeatherName("heavy_rain_night")).toBe("Rainy Night");
  });

  test("builds notch CSS variables from known safe areas", () => {
    expect(
      getNotchCssVariables({
        name: "Built-in Retina Display",
        width: 1512,
        height: 982,
      }),
    ).toBe("--notch-left: 663px; --notch-right: 848px; --notch-margin: 6px;");
  });

  test("detects the notch from a Tauri monitor without GlazeWM", () => {
    const monitor = toLogicalMonitor({
      name: "Built-in Retina Display",
      size: { width: 3024, height: 1964 },
      scaleFactor: 2,
    });

    expect(shouldDodgeNotch(monitor)).toBe(true);
    expect(getNotchCssVariables(monitor)).toBe(
      "--notch-left: 663px; --notch-right: 848px; --notch-margin: 6px;",
    );
  });
});
