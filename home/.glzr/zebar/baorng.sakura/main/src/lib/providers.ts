import * as zebar from "zebar";

export const providers = zebar.createProviderGroup({
  audio: { type: "audio" },
  cpu: { type: "cpu" },
  battery: { type: "battery" },
  memory: { type: "memory" },
  weather: { type: "weather" },
  date: { type: "date", formatting: "EEE d MMM t" },
  glazewm: { type: "glazewm" },
});

export type ProviderOutput = typeof providers.outputMap;
