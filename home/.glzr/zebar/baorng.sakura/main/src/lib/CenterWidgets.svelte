<script lang="ts">
  import type { DateOutput, WeatherOutput } from "zebar";
  import SystemIcon from "./icons/SystemIcon.svelte";
  import WeatherIcon from "./icons/WeatherIcon.svelte";
  import {
    getNotchCssVariables,
    getWeatherName,
    type MonitorLike,
    shouldDodgeNotch,
  } from "./view-model";

  let {
    date,
    nativeMonitor,
    weather,
  }: {
    date?: DateOutput;
    nativeMonitor?: MonitorLike;
    weather?: WeatherOutput;
  } = $props();

  let dodgeNotch = $derived(shouldDodgeNotch(nativeMonitor));
  let notchStyle = $derived(getNotchCssVariables(nativeMonitor));
</script>

<div
  class={`flex-fill anchor-centre spacing-10 ${dodgeNotch ? "notch-dodge" : ""}`}
  style={notchStyle}
>
  {#if weather}
    <div class="center-widget notch-left-widget group-container anchor-centre extra-padding">
      <WeatherIcon status={weather.status} />
      <p class="pad-5-lr">{getWeatherName(weather.status)}</p>
    </div>
  {/if}

  <div class="center-widget notch-right-widget group-container anchor-centre extra-padding">
    <SystemIcon name="clock" />
    <p class="pad-5-lr">{date?.formatted}</p>
  </div>
</div>
