<script lang="ts">
  import type { AudioOutput, BatteryOutput, CpuOutput, MemoryOutput } from "zebar";
  import BatteryIcon from "./icons/BatteryIcon.svelte";
  import SystemIcon from "./icons/SystemIcon.svelte";
  import VolumeIcon from "./icons/VolumeIcon.svelte";
  import { formatBatteryCharge } from "./view-model";

  let {
    audio,
    battery,
    cpu,
    memory,
  }: {
    audio?: AudioOutput;
    battery?: BatteryOutput;
    cpu?: CpuOutput;
    memory?: MemoryOutput;
  } = $props();
</script>

<div class="flex-fill anchor-centre-right spacing-10">
  {#if audio}
    <div class="group-container anchor-centre extra-padding">
      <VolumeIcon
        volumePercentage={audio.defaultPlaybackDevice.volume}
        isMuted={audio.defaultPlaybackDevice.isMuted}
      />
      <p class="pad-5-lr">Volume: {audio.defaultPlaybackDevice.volume}%</p>
    </div>
  {/if}

  {#if cpu}
    <div class="group-container anchor-centre extra-padding">
      <SystemIcon name="cpu" />
      <p class="pad-5-lr">CPU: {cpu.usage.toFixed()}%</p>
    </div>
  {/if}

  {#if memory}
    <div class="group-container anchor-centre extra-padding">
      <SystemIcon name="memory" />
      <p class="pad-5-lr">Memory: {memory.usage.toFixed()}%</p>
    </div>
  {/if}

  {#if battery}
    <div class="group-container anchor-centre extra-padding">
      <BatteryIcon
        chargePercent={battery.chargePercent}
        isCharging={battery.isCharging}
        state={battery.state}
      />
      <p class="pad-5-lr">Battery: {formatBatteryCharge(battery.chargePercent)}%</p>
    </div>
  {/if}
</div>
