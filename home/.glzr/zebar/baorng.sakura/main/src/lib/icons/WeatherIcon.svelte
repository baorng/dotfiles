<script lang="ts">
  import type { WeatherStatus } from "zebar";
  import Icon from "./Icon.svelte";
  import { WEATHER_ICON_PATHS } from "./weather-paths";

  let { status }: { status: WeatherStatus } = $props();
</script>

<Icon path={WEATHER_ICON_PATHS[status]} />
