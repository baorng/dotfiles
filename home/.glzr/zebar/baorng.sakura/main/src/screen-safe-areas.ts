export const SCREEN_SAFE_AREAS = [
  {
    name: "Mi Monitor",
    frame: { x: 0, y: 0, width: 2560, height: 1440 },
    auxiliaryTopLeftArea: null,
    auxiliaryTopRightArea: null,
  },
  {
    name: "Built-in Retina Display",
    frame: { x: 279, y: -982, width: 1512, height: 982 },
    auxiliaryTopLeftArea: { x: 279, y: -32, width: 663, height: 32 },
    auxiliaryTopRightArea: { x: 1127, y: -32, width: 664, height: 32 },
  },
] as const;
