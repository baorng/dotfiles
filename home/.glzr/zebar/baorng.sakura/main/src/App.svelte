<script lang="ts">
  import { currentMonitor, getCurrentWindow } from "@tauri-apps/api/window";
  import { onMount } from "svelte";
  import CenterWidgets from "./lib/CenterWidgets.svelte";
  import { providers, type ProviderOutput } from "./lib/providers";
  import SystemStats from "./lib/SystemStats.svelte";
  import { type MonitorLike, toLogicalMonitor } from "./lib/view-model";
  import { readCachedWeather, writeCachedWeather } from "./lib/weather-cache";
  import WorkspaceList from "./lib/WorkspaceList.svelte";

  let audio = $state<ProviderOutput["audio"]>(providers.outputMap.audio);
  let battery = $state<ProviderOutput["battery"]>(providers.outputMap.battery);
  let cpu = $state<ProviderOutput["cpu"]>(providers.outputMap.cpu);
  let date = $state<ProviderOutput["date"]>(
    providers.raw.date.output ?? providers.outputMap.date,
  );
  let glazewm = $state<ProviderOutput["glazewm"]>(providers.outputMap.glazewm);
  let memory = $state<ProviderOutput["memory"]>(providers.outputMap.memory);
  let nativeMonitor = $state<MonitorLike>();
  let weather = $state<ProviderOutput["weather"]>(
    readCachedWeather() ?? providers.outputMap.weather,
  );
  let isLight = $state(false);

  onMount(() => {
    const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");
    const updateTheme = () => {
      isLight = !mediaQuery.matches;
      document.body.classList.toggle("light", isLight);
    };

    updateTheme();
    mediaQuery.addEventListener("change", updateTheme);

    const updateNativeMonitor = async () => {
      try {
        nativeMonitor = toLogicalMonitor(await currentMonitor());
      } catch (error) {
        console.error("Failed to read Zebar monitor:", error);
      }
    };
    void updateNativeMonitor();

    const tauriWindow = getCurrentWindow();
    const unlistenMoved = tauriWindow.onMoved(updateNativeMonitor);
    const unlistenResized = tauriWindow.onResized(updateNativeMonitor);

    providers.onOutput((outputMap) => {
      if (outputMap.audio !== audio) audio = outputMap.audio;
      if (outputMap.battery !== battery) battery = outputMap.battery;
      if (outputMap.cpu !== cpu) cpu = outputMap.cpu;
      if (outputMap.date && outputMap.date !== date) date = outputMap.date;
      if (outputMap.glazewm !== glazewm) glazewm = outputMap.glazewm;
      if (outputMap.memory !== memory) memory = outputMap.memory;
      if (outputMap.weather && outputMap.weather !== weather) {
        weather = outputMap.weather;
        writeCachedWeather(outputMap.weather);
      }
    });

    return () => {
      mediaQuery.removeEventListener("change", updateTheme);
      void unlistenMoved.then((unlisten) => unlisten());
      void unlistenResized.then((unlisten) => unlisten());
    };
  });
</script>

<div class="app">
  <div class="bar-row fill-flow direction-horizontal relative-x pad-5 spacing-10">
    {#if glazewm}
      <WorkspaceList {glazewm} />
    {:else}
      <div class="flex-fill anchor-centre-left"></div>
    {/if}

    <CenterWidgets {nativeMonitor} {weather} {date} />
    <SystemStats
      {audio}
      {cpu}
      {memory}
      {battery}
    />
  </div>
</div>
