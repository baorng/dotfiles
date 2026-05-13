<script lang="ts">
  import type { BatteryOutput } from "zebar";
  import { batteryFillWidth } from "../view-model";

  let {
    chargePercent,
    isCharging,
    state,
  }: Pick<BatteryOutput, "chargePercent" | "isCharging" | "state"> = $props();

  let showBolt = $derived(isCharging || state === "charging");
</script>

<svg class="battery-icon" xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 0 24 24" width="20px">
  <path
    class="battery-icon-shell"
    d="M3.75 7.5h14.5a1.75 1.75 0 0 1 1.75 1.75v5.5a1.75 1.75 0 0 1-1.75 1.75H3.75A1.75 1.75 0 0 1 2 14.75v-5.5A1.75 1.75 0 0 1 3.75 7.5Zm17.25 2.75h1.25v3.5H21v-3.5ZM4 9.5v5h14v-5H4Z"
  ></path>
  <rect x="4.5" y="10" width={batteryFillWidth(chargePercent)} height="4" rx="1" fill="var(--accent)"></rect>
  {#if showBolt}
    <path class="battery-icon-bolt" d="M11.8 5.5 8.8 12h2.4l-1 6.5 4-8h-2.5l1.1-5Z"></path>
  {/if}
</svg>
