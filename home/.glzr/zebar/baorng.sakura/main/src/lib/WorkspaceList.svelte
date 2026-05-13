<script lang="ts">
  import type { GlazeWmOutput } from "zebar";
  import { isFocusedWorkspace } from "./view-model";

  let { glazewm }: { glazewm: GlazeWmOutput } = $props();
</script>

<div class="flex-fill anchor-centre-left">
  <div class="fill-flow spacing-5 group-container">
    {#each glazewm.currentWorkspaces as workspace (workspace.name)}
      <div
        class={`anchor-centre workspace-container ${
          isFocusedWorkspace(workspace, glazewm.focusedWorkspace) ? "workspace-active" : ""
        }`}
      >
        <p>•</p>
      </div>
    {/each}
  </div>
</div>
